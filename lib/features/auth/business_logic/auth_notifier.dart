import 'package:flutter/material.dart';

import '../data/auth_repository.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthRepository _repository;

  // En simpel bool eller enum til at styre om vi viser telefon- eller kodefeltet
  bool _codeSent = false;
  bool get codeSent => _codeSent;

  String _currentPhoneNumber = '';

  AuthNotifier(this._repository);

  // Trin 1: Send SMS
  Future<void> startPhoneAuth(String phoneNumber) async {
    try {
      _currentPhoneNumber = phoneNumber;
      await _repository.sendOtpToPhone(phoneNumber);
      _codeSent = true; // Nu ved UI'et, at vi skal vise kode-feltet
      notifyListeners();
    } catch (e) {
      print("Fejl ved telefonnummer otp: $e");
    }
  }

  // Trin 2: Verificer kode
  Future<void> verifyCode(String token) async {
    try {
      await _repository.verifyPhoneOtp(
        phoneNumber: _currentPhoneNumber,
        token: token,
      );
      // Succes! Supabase logger automatisk brugeren ind globalt nu
      _codeSent = false;
      notifyListeners();
    } catch (e) {
      // Håndter forkert kode-fejl
    }
  }
}
