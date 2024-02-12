import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService();

  final SupabaseClient _supabase = Supabase.instance.client;

  bool get isSignedIn => _supabase.auth.currentSession != null;

  User? get currentUser => _supabase.auth.currentUser;

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final AuthResponse res = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return res.user;
  }

  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    final AuthResponse res = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    return res.user;
  }

  Future<User?> verifySession(Uri url) async {
    AuthSessionUrlResponse res = await _supabase.auth.getSessionFromUrl(url);
    return res.session.user;
  }

  Future<void> resetPassword({required String email}) async {
    return await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: kIsWeb ? null : 'com.example.app/auth/callback',
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
