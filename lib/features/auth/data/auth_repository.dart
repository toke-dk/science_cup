
import 'package:science_cup_app/features/auth/data/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final _supabase = Supabase.instance.client;

  /// Henter den nuværende indloggede bruger og dennes profil fra public.profiles.
  /// Returnerer [null], hvis der ikke er en aktiv session.
  Future<Profile?> getLoggedInProfile() async {
    try {
      final sessionUser = _supabase.auth.currentUser;
      if (sessionUser == null) return null;

      // Hent de ekstra profil-data (f.eks. role) fra din public tabel
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', sessionUser.id)
          .single();

      return Profile.fromJson(data);
    } catch (e) {
      // Hvis noget fejler (f.eks. netværksfejl), returnerer vi null
      return null;
    }
  }

  /// Sender en SMS OTP til telefonnummeret (Husk landekode, f.eks. +4512345678)
  Future<void> sendOtpToPhone(String phoneNumber) async {
    try {
      await _supabase.auth.signInWithOtp(phone: phoneNumber);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Verificerer SMS-koden og returnerer den fulde [Profile]
  Future<Profile?> verifyPhoneOtp({
    required String phoneNumber,
    required String token,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        phone: phoneNumber,
        token: token,
        type: OtpType.sms,
      );

      if (response.user == null) throw Exception('Log ind fejlede');

      // Hent profil-data med det samme
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return Profile.fromJson(data);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Sender login-kode til e-mail
  Future<void> sendEmailOtp(String email) async {
    try {
      await _supabase.auth.signInWithOtp(
        email: email,
        emailRedirectTo: null,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Verificerer e-mail-koden og returnerer den fulde [Profile]
  Future<Profile?> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        type: OtpType.email,
        token: token,
        email: email,
      );

      if (response.user == null) throw Exception('Log ind fejlede');

      // Hent profil-data med det samme
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return Profile.fromJson(data);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Logger brugeren ud af Supabase
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }
}