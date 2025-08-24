import 'package:local_storage_datasource/datasource/local_storage.datasource.dart';
import 'package:shared/constant/auth_status.constant.dart';
import 'package:supabase_datasource/datasources/auth/auth.datasource_impl.dart';
import 'package:supabase_datasource/datasources/model/auth/auth_user.model.dart';

part 'auth.datasource.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final SupabaseAuthDataSource _supabaseAuthDataSource;
  final LocalStorageDataSource _localStorageDataSource;

  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  AuthDataSourceImpl({
    required SupabaseAuthDataSource supabaseAuthDataSource,
    required LocalStorageDataSource localStorageDataSource,
  }) : _supabaseAuthDataSource = supabaseAuthDataSource,
       _localStorageDataSource = localStorageDataSource;

  @override
  Stream<AuthStatus> get authStatusStream =>
      _supabaseAuthDataSource.authStatusStream;

  @override
  Future<AuthUserModel> getCurrentAuthUser() =>
      _supabaseAuthDataSource.getCurrentAuthUser();

  @override
  Future<(String, String?)> getNewTokensByRefreshToken(String refreshToken) =>
      _supabaseAuthDataSource.getNewTokensByRefreshToken(refreshToken);

  @override
  Future<(String, String?)> signInAndReturnTokens({
    required String email,
    required String password,
  }) => _supabaseAuthDataSource.signInAndReturnTokens(
    email: email,
    password: password,
  );

  @override
  Future<void> signOut() => _supabaseAuthDataSource.signOut();

  @override
  Future<(String, String?)> signUpAndReturnTokens({
    required String email,
    required String password,
    required String username,
    String? profileImage,
  }) => _supabaseAuthDataSource.signUpAndReturnTokens(
    email: email,
    password: password,
    username: username,
    profileImage: profileImage,
  );

  @override
  Future<void> deleteTokensInLocalStorage() async {
    await _localStorageDataSource.delete(_accessTokenKey);
    await _localStorageDataSource.delete(_refreshTokenKey);
  }

  @override
  Future<String> getRefreshTokenFromLocalStorage() async {
    return await _localStorageDataSource.read(_refreshTokenKey);
  }

  @override
  Future<void> saveTokensInLocalStorage({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _localStorageDataSource.write(
      key: _accessTokenKey,
      value: accessToken,
    );
    if (refreshToken != null || refreshToken!.isNotEmpty) {
      await _localStorageDataSource.write(
        key: _refreshTokenKey,
        value: refreshToken,
      );
    }
  }
}
