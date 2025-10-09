part of 'local_token.datasource.dart';

class LocalTokenDataSourceImpl implements LocalTokenDataSource {
  final FlutterSecureStorage _flutterSecureStorage;
  final Logger? _logger;

  LocalTokenDataSourceImpl(
    this._flutterSecureStorage, {
    required Logger? logger,
  }) : _logger = logger;

  static const String _accessTokenKey = 'APP_ACCESS_TOKEN';
  static const String _refreshTokenKey = 'APP_REFRESH_TOKEN';

  @override
  Future<(String? accessToken, String? refreshToken)> getTokens() async {
    final accessToken = await _flutterSecureStorage.read(key: _accessTokenKey);
    final refreshToken = await _flutterSecureStorage.read(
      key: _refreshTokenKey,
    );
    return (accessToken, refreshToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _flutterSecureStorage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> saveTokens({String? accessToken, String? refreshToken}) async {
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
  }

  @override
  Future<void> clearTokens() async {
    await _flutterSecureStorage.delete(key: _accessTokenKey);
    await _flutterSecureStorage.delete(key: _refreshTokenKey);
  }
}
