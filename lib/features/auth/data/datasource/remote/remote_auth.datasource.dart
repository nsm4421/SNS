part of 'remote_auth.datasource_impl.dart';

abstract interface class RemoteAuthDataSource {
  Stream<AuthState> get authStateStream;

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  });

  Future<(String accessToken, String refreshToken)> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<Session?> restoreSession(String refreshToken);
}
