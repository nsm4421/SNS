part of 'local_token.datasource.dart';

class LocalTokenDataSourceImpl implements LocalTokenDataSource {
  final FlutterSecureStorage _flutterSecureStorage;
  final Logger? _logger;

  LocalTokenDataSourceImpl({
    required FlutterSecureStorage flutterSecureStorage,
    required Logger? logger,
  }) : _flutterSecureStorage = flutterSecureStorage,
       _logger = logger;

  static const String _accessTokenKey = 'APP_ACCESS_TOKEN';
  static const String _refreshTokenKey = 'APP_REFRESH_TOKEN';

  @override
  Future<(String? accessToken, String? refreshToken)> getTokens() async {
    try {
      final accessToken = await _flutterSecureStorage.read(
        key: _accessTokenKey,
      );
      final refreshToken = await _flutterSecureStorage.read(
        key: _refreshTokenKey,
      );
      return (accessToken, refreshToken);
    } catch (e, st) {
      _logger?.e('local storage exception', error: e, stackTrace: st);
      throw CustomException.localStorage();
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _flutterSecureStorage.read(key: _refreshTokenKey);
    } catch (e, st) {
      _logger?.e('local storage exception', error: e, stackTrace: st);
      throw CustomException.localStorage();
    }
  }

  @override
  Future<void> saveTokens({String? accessToken, String? refreshToken}) async {
    try {
      if (accessToken == null && refreshToken == null) {
        _logger?.w('both access, refresh token are not given');
      }
      if (accessToken != null) {
        await _flutterSecureStorage.write(
          key: _accessTokenKey,
          value: accessToken,
        );
      }
      if (refreshToken != null) {
        await _flutterSecureStorage.write(
          key: _refreshTokenKey,
          value: refreshToken,
        );
      }
    } catch (e, st) {
      _logger?.e('local storage exception', error: e, stackTrace: st);
      throw CustomException.localStorage();
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await _flutterSecureStorage.delete(key: _accessTokenKey);
      await _flutterSecureStorage.delete(key: _refreshTokenKey);
    } catch (e, st) {
      _logger?.e('local storage exception', error: e, stackTrace: st);
      throw CustomException.localStorage();
    }
  }
}
