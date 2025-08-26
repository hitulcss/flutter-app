part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoadingAuth extends AuthState {}

class ErrorAuth extends AuthState {}

class ErrorSnackbar extends AuthState {
  final String msg;

  ErrorSnackbar({required this.msg});
}

class RegisterSuccess extends AuthState {}

class LoginSuccess extends AuthState {
  final int optlength;

  LoginSuccess({required this.optlength});
}

//OTP Verification
class VerificationOtpLoading extends AuthState {}

class VerificationOtpSuccess extends AuthState {
  final bool newUser;
  VerificationOtpSuccess({required this.newUser});
}

class VerificationOtpError extends AuthState {}

class ResendOtpSuccess extends AuthState {}

class UpdateLanguageStreamSuccess extends AuthState {}

class UnVerifiedNumber extends AuthState {
  final String phoneNumber;
  UnVerifiedNumber({required this.phoneNumber});
}

class RequestToLogout extends AuthState {}

class GoogleSuccess extends AuthState {}

class GoogleAddPhoneNumberLoading extends AuthState {}

class GoogleAddPhonenumber extends AuthState {}

class GoogleAddPhonenumberError extends AuthState {}

class GooglePhoneNumberVerification extends AuthState {}

class GoogleAuthRequestToLogout extends AuthState {
  final String email;
  GoogleAuthRequestToLogout({required this.email});
}

class RequestLogoutSuccess extends AuthState {}

//RESET PASSWORD CUBIT
class UpdatePasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {}

class UpdatePasswordOtpResend extends AuthState {}

class UpdatePasswordOtpVerifySuccess extends AuthState {}

class UpdatePasswordSuccess extends AuthState {}

class UpdatePasswordError extends AuthState {}
