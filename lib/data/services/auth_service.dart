import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superfrog/utils/captcha.dart';
import 'package:superfrog/utils/platform.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool get isSignedIn => _supabase.auth.currentSession != null;

  User? get currentUser => _supabase.auth.currentSession?.user;

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final AuthResponse res = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
      captchaToken: await Captcha.getToken(),
    );
    return res.user;
  }

  Future<User?> signUp({required String email, required String password}) async {
    final AuthResponse res = await _supabase.auth.signUp(
      email: email,
      password: password,
      captchaToken: await Captcha.getToken(),
    );
    return res.user;
  }

  Future<User?> signInWithGoogle() async {
    if (PlatformUtils.isMobile) {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: const String.fromEnvironment('GOOGLE_IOS_CLIENT_ID'),
        serverClientId: const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID'),
      );

      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw const AuthException('Authentication canceled');
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw const AuthException('No Access Token found.');
      }

      if (idToken == null) {
        throw const AuthException('No ID Token found.');
      }

      final AuthResponse res = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return res.user;
    } else {
      _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      await Future.delayed(const Duration(seconds: 600)).then(
        (value) => throw const AuthException('Authentication timeout.'),
      );
    }
  }

  Future<User?> signInWithApple() async {
    /*  final rawNonce = _supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: const String.fromEnvironment('APPLE_CLIENT_ID'),
        redirectUri: Uri.parse("example"),
      ),
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException('Could not find ID Token from generated credential.');
    }

    final AuthResponse res = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );

    return res.user; */

    throw UnimplementedError();
  }

  Future<void> signInWithOTP(String? email) async {
    return _supabase.auth.signInWithOtp(email: email, captchaToken: await Captcha.getToken());
  }

  Future<User?> verifySession(Uri url) async {
    AuthSessionUrlResponse res = await _supabase.auth.getSessionFromUrl(url);
    return res.session.user;
  }

  Future<void> resetPassword({required String email}) async {
    return _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: kIsWeb ? null : 'com.example.app/auth/callback',
      captchaToken: await Captcha.getToken(),
    );
  }

  Future<User?> verifyToken({required String token, OtpType type = OtpType.recovery}) async {
    final res = await _supabase.auth.verifyOTP(
      email: '',
      token: '',
      tokenHash: token,
      type: OtpType.recovery,
      captchaToken: await Captcha.getToken(),
    );
    return res.user;
  }

  Future<User?> updatePassword(String password) async {
    UserResponse? res = await _supabase.auth.updateUser(UserAttributes(password: password));
    return res.user;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    if (PlatformUtils.isMobile) {
      if (GoogleSignIn().currentUser != null) {
        await GoogleSignIn().disconnect();
      }
    }
  }
}
