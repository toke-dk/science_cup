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
  late final AuthRepository _repo;
  StreamSubscription<supabase.AuthState>? _authStateSubscription;

  @override
  AuthState build() {
    _repo = ref.read(authRepositoryProvider);

    // Lyt permanent på auth‑ændringer (login/logout/token refresh)
    _startListeningToAuthChanges();

    // Tjek den aktuelle session ved opstart (første load)
    _checkInitialSession();

    ref.onDispose(() {
      _authStateSubscription?.cancel();
    });

    // Vis loader indtil _checkInitialSession eller listener har opdateret state
    return const AuthState(isLoading: true);
  }

  // --- PRIVATE HJÆLPERE ---

  void _startListeningToAuthChanges() {
    _authStateSubscription = supabase
        .Supabase
        .instance
        .client
        .auth
        .onAuthStateChange
        .listen((event) async {
          // Logget helt ud → nulstil alt
          if (event.session == null) {
            state = const AuthState();
            return;
          }

          // Ved login, token‑refresh eller initial session → hent profil hvis den ikke er der
          if (event.event == supabase.AuthChangeEvent.signedIn ||
              event.event == supabase.AuthChangeEvent.tokenRefreshed ||
              event.event == supabase.AuthChangeEvent.initialSession) {
            // Undgå unødvendige kald hvis profilen allerede er hentet
            if (state.profile == null) {
              try {
                final profile = await _repo.getLoggedInProfile();
                state = state.copyWith(profile: profile, isLoading: false);
              } catch (_) {
                state = state.copyWith(
                  isLoading: false,
                  errorMessage: 'Kunne ikke hente profil.',
                );
              }
            }
          }
        });
  }

  Future<void> _checkInitialSession() async {
    try {
      final session = supabase.Supabase.instance.client.auth.currentSession;
      if (session != null) {
        final profile = await _repo.getLoggedInProfile();
        state = state.copyWith(profile: profile, isLoading: false);
      } else {
        // Ingen session – klar til at vise login‑knap
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Sæt loading og ryd samtidig eventuelle fejl
  void _setLoading(bool value) {
    state = state.copyWith(
      isLoading: value,
      errorMessage: value ? null : state.errorMessage,
    );
  }

  // --- PHONE AUTH FLOW ---

  Future<void> startPhoneAuth(String phoneNumber) async {
    _setLoading(true);
    try {
      await _repo.sendOtpToPhone(phoneNumber);
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
      final newUser = await _repo.verifyPhoneOtp(
        phoneNumber: state.currentPhoneNumber,
        token: token,
      );
      state = AuthState(profile: newUser);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Forkert eller udløbet SMS‑kode.',
      );
      return false;
    }
  }

  // --- EMAIL AUTH FLOW ---

  Future<void> sendEmailOtp(String email) async {
    _setLoading(true);
    try {
      await _repo.sendEmailOtp(email);
      state = state.copyWith(emailCodeSent: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    _setLoading(true);
    try {
      final newUser = await _repo.verifyEmailOtp(email: email, token: token);
      state = AuthState(profile: newUser);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Kunne ikke logge ind. Tjek koden i din e‑mail.',
      );
      return false;
    }
  }

  // --- LOG UD ---

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _repo.signOut();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
