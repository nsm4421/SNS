part of 'auth.datasource_impl.dart';

abstract interface class SupabaseAuthDataSource {
  Stream<AuthStatus> get authStatusStream;

  Future<AuthUserModel> getCurrentAuthUser();

  String? get currentUid;

  Future<(String accessToken, String? refreshToken)> signUpAndReturnTokens({
    required String email,
    required String password,
    required String username,
    String? profileImage,
  });

  Future<(String accessToken, String? refreshToken)> signInAndReturnTokens({
    required String email,
    required String password,
  });

  Future<(String accessToken, String? refreshToken)> getNewTokensByRefreshToken(
    String refreshToken,
  );

  Future<void> signOut();
}
