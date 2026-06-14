import 'dart:async';
import 'package:flutter/material.dart';
import 'package:science_cup_app/features/auth/data/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../data/auth_repository.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthRepository _repository;
  StreamSubscription<supabase.AuthState>? _authStateSubscription;

  AuthNotifier(this._repository) {
    _initializeAuth();
  }

  // --- GLOBALE AUTH TILSTANDE ---
  Profile? _profile;
  Profile? get profile => _profile;

  bool get isAuthenticated => _profile != null;

  // --- LOKALE UI/FORMULAR TILSTANDE ---
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _phoneCodeSent = false;
  bool get phoneCodeSent => _phoneCodeSent;

  bool _emailCodeSent = false;
  bool get emailCodeSent => _emailCodeSent;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _currentPhoneNumber = '';

  /// Initialiserer auth-tilstanden ved opstart og lytter på ændringer (f.eks. udløb af session)
  Future<void> _initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    // Tjek om der allerede er en aktiv bruger i databasen ved app-start
    _profile = await _repository.getLoggedInProfile();
    _isLoading = false;
    notifyListeners();

    // Lyt til ændringer i baggrunden (f.eks. hvis brugeren bliver logget ud udefra)
    _authStateSubscription = supabase.Supabase.instance.client.auth.onAuthStateChange.listen((event) async {
      if (event.session == null) {
        _profile = null;
        _resetFormStates();
        notifyListeners();
      } else if (_profile == null) {
        // Hvis sessionen pludselig opstår udefra, henter vi profilen
        _profile = await _repository.getLoggedInProfile();
        notifyListeners();
      }
    });
  }

  // --- PHONE AUTH FLOW ---

  /// Trin 1: Send SMS OTP
  Future<void> startPhoneAuth(String phoneNumber) async {
    _setLoading(true);
    try {
      _currentPhoneNumber = phoneNumber;
      await _repository.sendOtpToPhone(phoneNumber);
      _phoneCodeSent = true;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Trin 2: Verificer SMS-kode
  Future<bool> verifyPhoneCode(String token) async {
    _setLoading(true);
    try {
      // Dit repository returnerer nu din egen typesikre User model!
      final newUser = await _repository.verifyPhoneOtp(
        phoneNumber: _currentPhoneNumber,
        token: token,
      );
      _profile = newUser;
      _phoneCodeSent = false;
      return true;
    } catch (e) {
      _errorMessage = "Forkert eller udløbet SMS-kode.";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // --- EMAIL AUTH FLOW ---

  /// Trin 1: Send login-link/kode til mail
  Future<void> sendEmailOtp(String email) async {
    _setLoading(true);
    try {
      await _repository.sendEmailOtp(email);
      _emailCodeSent = true;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Trin 2: Verificer e-mail-kode
  Future<bool> verifyEmailOtp({required String email, required String token}) async {
    _setLoading(true);
    try {
      final newUser = await _repository.verifyEmailOtp(email: email, token: token);
      _profile = newUser;
      _emailCodeSent = false;
      return true;
    } catch (e) {
      _errorMessage = "Kunne ikke logge ind. Tjek koden i din e-mail.";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // --- LOG UD ---
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _repository.signOut();
      _profile = null;
      _resetFormStates();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // --- HJÆLPEFUNKTIONER ---

  void _setLoading(bool value) {
    _isLoading = value;
    if (value) _errorMessage = null; // Nulstil fejlbesked, når vi starter en ny handling
    notifyListeners();
  }

  void _resetFormStates() {
    _phoneCodeSent = false;
    _emailCodeSent = false;
    _errorMessage = null;
    _currentPhoneNumber = '';
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}