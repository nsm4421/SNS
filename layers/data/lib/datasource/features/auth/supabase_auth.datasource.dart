part of 'supabase_auth.datasource_impl.dart';

abstract interface class SupabaseAuthDataSource {
  Stream<AuthState> get authStateStream;

  Future<AuthUserModel> getCurrentAuthUser();

  Future<(String accessToken, String? refreshToken)> signUpAndReturnTokens(
    SignUpRequestDto dto,
  );

  Future<(String accessToken, String? refreshToken)> signInAndReturnTokens({
    required String email,
    required String password,
  });

  Future<(String accessToken, String? refreshToken)> getNewTokensByRefreshToken(
    String refreshToken,
  );

  Future<void> signOut();
}
