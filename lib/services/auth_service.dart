import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/supabase_config.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // IMPORTANT: serverClientId must be the WEB client ID from Google Console
  // Go to: console.cloud.google.com → APIs & Services → Credentials
  // Use the "Web application" OAuth 2.0 Client ID (NOT the Android one)
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: '1035190657774-2nib1n4h2cpg9qa036njcrqrtlgigbc8.apps.googleusercontent.com',
  );

  User? get currentUser => _supabase.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  // ─── Sign Up ──────────────────────────────────────────────────────────────
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      return response;
    } on AuthException catch (e) {
      if (e.statusCode == '429' || e.message.contains('rate limit')) {
        throw Exception('Too many attempts. Please wait a few minutes and try again.');
      } else if (e.message.toLowerCase().contains('already registered')) {
        throw Exception('This email is already registered. Please log in instead.');
      }
      throw Exception(e.message);
    }
  }

  // ─── Sign In ──────────────────────────────────────────────────────────────
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        throw Exception('Invalid email or password.');
      } else if (e.message.contains('Email not confirmed')) {
        throw Exception('Please verify your email before logging in.');
      }
      throw Exception(e.message);
    }
  }

  // ─── Google Sign In ───────────────────────────────────────────────────────
  Future<bool> signInWithGoogle() async {
    // Sign out first to force account picker every time
    await _googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      // User cancelled — not an error
      return false;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final String? idToken = googleAuth.idToken;
    final String? accessToken = googleAuth.accessToken;

    if (idToken == null) {
      throw Exception(
        'Google sign-in failed: No ID token received. '
        'Make sure serverClientId is the WEB client ID from Google Console.',
      );
    }

    if (accessToken == null) {
      throw Exception(
        'Google sign-in failed: No access token received. '
        'Check your OAuth scopes and SHA-1 fingerprint in Google Console.',
      );
    }

    // Supabase requires BOTH idToken and accessToken
    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    return response.user != null;
  }

  // ─── Sign Out ─────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _supabase.auth.signOut();
  }

  // ─── Reset Password ───────────────────────────────────────────────────────
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // ─── Update User Metadata ─────────────────────────────────────────────────
  Future<void> updateUserMetadata({String? fullName, String? avatarUrl}) async {
    try {
      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      await _supabase.auth.updateUser(
        UserAttributes(data: updates),
      );
    } catch (e) {
      rethrow;
    }
  }

  // ─── Auth State Stream ────────────────────────────────────────────────────
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}