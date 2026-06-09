import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/auth_repository.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthRepository _repository;
  late final StreamSubscription<AuthState> _authStateSubscription;

  AuthNotifier(this._repository) {
    _isAuthenticated = Supabase.instance.client.auth.currentSession != null;
    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      _isAuthenticated = event.session != null;
      notifyListeners();
    });
  }

  // Phone
  bool _codeSent = false;
  bool get codeSent => _codeSent;

  String _currentPhoneNumber = '';
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;


  // Trin 1: Send SMS
  Future<void> startPhoneAuth(String phoneNumber) async {
    try {
      _currentPhoneNumber = phoneNumber;
      await _repository.sendOtpToPhone(phoneNumber);
      _codeSent = true; // Nu ved UI'et, at vi skal vise kode-feltet
      notifyListeners();
    } catch (e) {
      debugPrint("Fejl ved telefonnummer otp: $e");
    }
  }

  // Trin 2: Verificer kode
  Future<bool> verifyCode(String token) async {
    try {
      await _repository.verifyPhoneOtp(
        phoneNumber: _currentPhoneNumber,
        token: token,
      );
      _codeSent = false;
      _isAuthenticated = Supabase.instance.client.auth.currentSession != null;
      notifyListeners();
      return _isAuthenticated;
    } catch (e) {
      // Håndter forkert kode-fejl
      return false;
    }
  }

  // Email
  bool _isLoading = false;
  bool _emailCodeSent = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get emailCodeSent => _emailCodeSent;
  String? get errorMessage => _errorMessage;

  // 1. Send koden til mail
  Future<void> sendEmailOtp(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.sendEmailOtp(email);
      _emailCodeSent = true;
      debugPrint("successfully sent email otp to $email");
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. Verificer koden
  Future<bool> verifyEmailOtp({required String email, required String token}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.verifyEmailOtp(email: email, token: token);
      _isAuthenticated = Supabase.instance.client.auth.currentSession != null;
      debugPrint("Sucess med verificering");
      return _isAuthenticated;
    } catch (e) {
      _errorMessage = "Fejl: Kunne ikke logge ind. Tjek koden. ($e)";
      debugPrint("Error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }
}
