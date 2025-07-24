import 'package:sns/core/util/logger/sington_logger.util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'remote_auth.datasource.dart';

class RemoteAuthDataSourceImpl with AppLogger implements RemoteAuthDataSource {
  final GoTrueClient _auth;

  RemoteAuthDataSourceImpl(this._auth);

  @override
  Stream<AuthState> get authStateStream => _auth.onAuthStateChange;

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final response = await _auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
    if (response.user == null) {
      throw const AuthException('sign up failed');
    }
  }

  @override
  Future<(String accessToken, String refreshToken)> signIn({
    required String email,
    required String password,
  }) async {
    final session = await _auth
        .signInWithPassword(email: email, password: password)
        .then((res) => res.session);

    if (session == null) {
      throw const AuthException('invalid session');
    } else if (session.accessToken.isEmpty) {
      throw const AuthException('access token is missing');
    } else if (session.refreshToken?.isEmpty != false) {
      throw const AuthException('refresh token is invalid');
    }

    return (session.accessToken, session.refreshToken!);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut(scope: SignOutScope.global);
  }

  @override
  Future<Session?> restoreSession(String refreshToken) async {
    return await _auth.setSession(refreshToken).then((res) => res.session);
  }
}
