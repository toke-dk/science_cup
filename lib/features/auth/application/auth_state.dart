// features/auth/application/auth_state.dart
import 'package:science_cup_app/features/auth/data/profile.dart';
import 'package:science_cup_app/features/auth/data/profile_role.dart';

class AuthState {
  final Profile? profile;
  final bool isLoading;
  final bool phoneCodeSent;
  final bool emailCodeSent;
  final String? errorMessage;
  final String currentPhoneNumber; // midlertidig, bruges under verifyPhoneCode

  const AuthState({
    this.profile,
    this.isLoading = false,
    this.phoneCodeSent = false,
    this.emailCodeSent = false,
    this.errorMessage,
    this.currentPhoneNumber = '',
  });

  bool get isAuthenticated => profile != null;
  ProfileRole? get profileRole => profile?.role;

  AuthState copyWith({
    Profile? profile,
    bool? isLoading,
    bool? phoneCodeSent,
    bool? emailCodeSent,
    String? errorMessage,
    String? currentPhoneNumber,
    bool clearProfile = false,
    bool clearError = false,
  }) {
    return AuthState(
      profile: clearProfile ? null : profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      phoneCodeSent: phoneCodeSent ?? this.phoneCodeSent,
      emailCodeSent: emailCodeSent ?? this.emailCodeSent,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentPhoneNumber: currentPhoneNumber ?? this.currentPhoneNumber,
    );
  }
}
