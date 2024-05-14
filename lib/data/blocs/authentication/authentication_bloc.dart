import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfrog/data/services/auth_service.dart';
import 'package:superfrog/routes/app_routes.dart';
import 'package:superfrog/utils/catch_async.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superfrog/utils/extensions.dart';

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
            emit(const AuthenticationState.error('You are already logged in'));
            return await Future.delayed(const Duration(seconds: 2)).then((_) {
              AppRouter.router.refresh();
            });
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

    on<_SignInWithGoogle>(
      (event, emit) => catchAsync(
        () async {
          emit(const AuthenticationState.loading());

          if (_authService.isSignedIn) {
            emit(const AuthenticationState.error('You are already logged in'));
            return await Future.delayed(const Duration(seconds: 2)).then((_) {
              AppRouter.router.refresh();
            });
          }

          final User? user = await _authService.signInWithGoogle();

          emit(AuthenticationState.authenticated(user));
        },
        onError: (error) => emit(AuthenticationState.error(error)),
      ),
    );

    on<_SignInWithApple>(
      (event, emit) => catchAsync(
        () async {
          emit(const AuthenticationState.loading());

          if (_authService.isSignedIn) {
            emit(const AuthenticationState.error('You are already logged in'));
            return await Future.delayed(const Duration(seconds: 2)).then((_) {
              AppRouter.router.refresh();
            });
          }

          final User? user = await _authService.signInWithApple();

          emit(AuthenticationState.authenticated(user));
        },
        onError: (error) => AuthenticationState.error(error),
      ),
    );

    on<_SignUpWithPassword>(
      (event, emit) => catchAsync(
        () async {
          emit(const AuthenticationState.loading());

          if (_authService.isSignedIn) {
            emit(const AuthenticationState.error('You are already logged in'));
            return await Future.delayed(const Duration(seconds: 2)).then((_) {
              AppRouter.router.refresh();
            });
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

    on<_SignOut>(
      (event, emit) => catchAsync(
        () async {
          emit(const AuthenticationState.loading());

          if (!_authService.isSignedIn) {
            emit(const AuthenticationState.error('You`re already out!'));
            return await Future.delayed(const Duration(seconds: 2)).then((_) {
              emit(const AuthenticationState.unAuthenticated());
              AppRouter.router.refresh();
            });
          }

          await _authService.signOut();

          await Future.delayed(const Duration(seconds: 2));

          emit(const AuthenticationState.unAuthenticated());
        },
        onError: (error) => emit(AuthenticationState.error(error)),
      ),
    );

    on<_UpdatePassword>(
      (event, emit) => catchAsync(
        () async {
          emit(const AuthenticationState.loading());

          if (!_authService.isSignedIn) {
            if (event.token.isNullOrEmpty) {
              return emit(const AuthenticationState.error("Token is not valid or expired."));
            }

            await _authService.verifyToken(token: event.token!);
          }

          User? newUser = await _authService.updatePassword(event.password);

          emit(const AuthenticationState.message("Succesfuly changed password page will redirect in few secounds"));
          await Future.delayed(const Duration(seconds: 5)).then((_) {
            emit(AuthenticationState.authenticated(newUser));
            AppRouter.router.refresh();
          });
        },
        onError: (error) => emit(AuthenticationState.error(error)),
      ),
    );
  }
}
