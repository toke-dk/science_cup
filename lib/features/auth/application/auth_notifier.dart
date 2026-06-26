// features/auth/application/auth_notifier.dart
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/auth/application/auth_repository_provider.dart';
import 'package:science_cup_app/features/auth/data/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'auth_state.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  StreamSubscription<supabase.AuthState>? _authStateSubscription;

  @override
  AuthState build() {
    // Start initial loading
    final repo = ref.read(authRepositoryProvider);
    final initialState = AuthState(isLoading: true);

    // Udfør asynkron initialisering
    _initialize(repo);

    // Ryd op når provideren lukkes
    ref.onDispose(() {
      _authStateSubscription?.cancel();
    });

    return initialState;
  }

  Future<void> _initialize(AuthRepository repo) async {
    try {
      final profile = await repo.getLoggedInProfile();
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }

    // Lyt på auth‑ændringer fra Supabase i baggrunden
    _authStateSubscription = supabase
        .Supabase
        .instance
        .client
        .auth
        .onAuthStateChange
        .listen((event) async {
          if (event.session == null) {
            // Bruger logget ud
            state = AuthState(); // reset alt
          } else if (state.profile == null) {
            // Session opstået eksternt – hent profil
            try {
              final profile = await ref
                  .read(authRepositoryProvider)
                  .getLoggedInProfile();
              state = state.copyWith(profile: profile);
            } catch (_) {}
          }
        });
  }

  // --- HJÆLPEMETODER ---
  void _setLoading(bool value) {
    state = state.copyWith(isLoading: value, clearError: value);
  }

  // --- PHONE AUTH FLOW ---
  Future<void> startPhoneAuth(String phoneNumber) async {
    _setLoading(true);
    try {
      await ref.read(authRepositoryProvider).sendOtpToPhone(phoneNumber);
      state = state.copyWith(
        phoneCodeSent: true,
        currentPhoneNumber: phoneNumber,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> verifyPhoneCode(String token) async {
    _setLoading(true);
    try {
      final newUser = await ref
          .read(authRepositoryProvider)
          .verifyPhoneOtp(phoneNumber: state.currentPhoneNumber, token: token);
      state = AuthState(profile: newUser); // reset UI-flags
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Forkert eller udløbet SMS-kode.",
      );
      return false;
    }
  }

  // --- EMAIL AUTH FLOW ---
  Future<void> sendEmailOtp(String email) async {
    _setLoading(true);
    try {
      await ref.read(authRepositoryProvider).sendEmailOtp(email);
      state = state.copyWith(emailCodeSent: true, isLoading: false);
    } catch (e) {
      print('Error sending email OTP: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    _setLoading(true);
    try {
      final newUser = await ref
          .read(authRepositoryProvider)
          .verifyEmailOtp(email: email, token: token);
      state = AuthState(profile: newUser);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Kunne ikke logge ind. Tjek koden i din e-mail.",
      );
      return false;
    }
  }

  // --- LOG UD ---
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = AuthState(); // rydder alt
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
