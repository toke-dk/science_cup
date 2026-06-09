import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final _supabase = Supabase.instance.client;

  // 1. Send SMS OTP til telefonnummeret (Husk landekode, f.eks. +4512345678)
  Future<void> sendOtpToPhone(String phoneNumber) async {
    await _supabase.auth.signInWithOtp(
      phone: phoneNumber,
    );
  }

  // 2. Verificer koden som brugeren indtaster
  Future<AuthResponse> verifyPhoneOtp({
    required String phoneNumber,
    required String token, // Den 6-cifrede kode fra SMS'en
  }) async {
    final response = await _supabase.auth.verifyOTP(
      phone: phoneNumber,
      token: token,
      type: OtpType.sms,
    );
    return response;
  }
}