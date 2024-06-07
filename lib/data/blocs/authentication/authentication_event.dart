part of 'authentication_bloc.dart';

@immutable
@Freezed(
  copyWith: false,
  toStringOverride: false,
  equal: false,
  when: FreezedWhenOptions.none,
  map: FreezedMapOptions.none,
)
class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.start() = _StartAuthentication;

  const factory AuthenticationEvent.signInWithPassword({
    required String email,
    required String password,
  }) = _SignInWithPassword;

  const factory AuthenticationEvent.signInWithGoogle() = _SignInWithGoogle;

  const factory AuthenticationEvent.signInWithApple() = _SignInWithApple;

  const factory AuthenticationEvent.signInWithMagicLink({
    String? email,
    String? token,
  }) = _SignInWithMagicLink;

  const factory AuthenticationEvent.signUpWithPassword({
    required String email,
    required String password,
  }) = _SignUpWithPassword;

  const factory AuthenticationEvent.resetPassword({
    required String email,
  }) = _ResetPassword;

  const factory AuthenticationEvent.updatePassword({
    String? token,
    required String password,
  }) = _UpdatePassword;

  const factory AuthenticationEvent.verifyOTP({
    String? email,
    required String token,
    required OtpType type,
    Function()? onVerified,
  }) = _VerifyOTP;

  const factory AuthenticationEvent.signOut() = _SignOut;
}
