part of 'auth.datasource_impl.dart';

abstract interface class AuthDataSource implements SupabaseAuthDataSource {
  Future<void> saveTokensInLocalStorage({
    required String accessToken,
    String? refreshToken,
  });

  Future<void> deleteTokensInLocalStorage();

  Future<String> getRefreshTokenFromLocalStorage();
}
