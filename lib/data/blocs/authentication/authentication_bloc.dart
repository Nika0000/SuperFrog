import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfrog/data/services/auth_service.dart';
import 'package:superfrog/utils/catch_async.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'authentication_state.dart';
part 'authentication_event.dart';
part 'authentication_bloc.freezed.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService _authService = AuthService();

  AuthenticationBloc() : super(const AuthenticationState.unitialized()) {
    on<_StartAuthentication>(
      (event, emit) {
        emit(const AuthenticationState.loading());

        if (!_authService.isSignedIn || _authService.currentUser == null) {
          return emit(const AuthenticationState.unAuthenticated());
        }

        emit(AuthenticationState.authenticated(_authService.currentUser!));
      },
    );

    on<_SignInWithPassword>(
      (event, emit) => catchAsync(
        () async {
          emit(const AuthenticationState.loading());

          if (_authService.isSignedIn) {
            return emit(
              const AuthenticationState.error('You are already logged in'),
            );
          }

          await Future.delayed(const Duration(seconds: 2));

          final User? user = await _authService.signIn(
            email: event.email,
            password: event.password,
          );

          emit(AuthenticationState.authenticated(user));
        },
        onError: (error) => emit(AuthenticationState.error(error)),
      ),
    );

    on<_SignUpWithPassword>(
      (event, emit) => catchAsync(
        () async {
          emit(const AuthenticationState.loading());

          if (_authService.isSignedIn) {
            return emit(const AuthenticationState.error('You are already logged in'));
          }

          final User? user = await _authService.signUp(
            email: event.email,
            password: event.password,
          );

          emit(AuthenticationState.authenticated(user));
        },
        onError: (error) => emit(AuthenticationState.error(error)),
      ),
    );

    on<_ResetPassword>(
      (event, emit) => catchAsync(
        () async {
          emit(const AuthenticationState.loading());

          await _authService.resetPassword(email: event.email);

          if (_authService.isSignedIn) {
            return emit(AuthenticationState.authenticated(_authService.currentUser));
          }

          emit(
            const AuthenticationState.message(
              'If you registered using your email and password, you will receive a password reset email.',
            ),
          );
          emit(const AuthenticationState.unitialized());
        },
        onError: (error) => emit(AuthenticationState.error(error)),
      ),
    );

    on<_VerifyRecoveryOTP>(
      (event, emit) => catchAsync(
        () async {
          emit(const AuthenticationState.loading());

          await _authService.verifyOTP(
            email: event.email,
            token: event.token,
          );

          print('invoke function');
        },
        onError: (error) => emit(AuthenticationState.error(error)),
      ),
    );

    on<_SignOut>(
      (event, emit) => catchAsync(
        () async {
          emit(const AuthenticationState.loading());

          if (!_authService.isSignedIn) {
            return emit(const AuthenticationState.error('You`re already out'));
          }

          await _authService.signOut();

          await Future.delayed(const Duration(seconds: 2));

          emit(const AuthenticationState.unAuthenticated());
        },
        onError: (error) => emit(AuthenticationState.error(error)),
      ),
    );

    on<_VerifySession>(
      (event, emit) => catchAsync(
        () async {
          emit(const AuthenticationState.loading());

          if (_authService.isSignedIn) {
            return emit(const AuthenticationState.error('You are already logged in'));
          }

          final User? user = await _authService.verifySession(event.url);

          emit(AuthenticationState.authenticated(user));
        },
        onError: (error) => emit(AuthenticationState.error(error)),
      ),
    );
  }
}
