part of 'authentication_bloc.dart';

@Freezed(
  copyWith: false,
  toStringOverride: false,
  equal: false,
  when: FreezedWhenOptions(when: false),
  map: FreezedMapOptions.none,
)
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.unitialized() = _Unitialized;
  const factory AuthenticationState.loading() = _Loading;
  const factory AuthenticationState.authenticated(User? user) = _Authenticated;
  const factory AuthenticationState.unAuthenticated() = _UaAuthenticated;
  const factory AuthenticationState.message(String message) = _AuthenticationMessage;
  const factory AuthenticationState.error(String message) = _AuthenticationError;
}
