import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'local_session.datasource.dart';

class LocalSessionDataSourceImpl implements LocalSessionDataSource {
  final FlutterSecureStorage _flutterSecureStorage;

  LocalSessionDataSourceImpl(this._flutterSecureStorage);

  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  @override
  Future<String?> getAccessToken() async {
    return await _flutterSecureStorage.read(key: _accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _flutterSecureStorage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> setAccessToken(String token) async {
    await _flutterSecureStorage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<void> setRefreshToken(String token) async {
    await _flutterSecureStorage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<void> clearAccessToken() async {
    await _flutterSecureStorage.delete(key: _accessTokenKey);
  }

  @override
  Future<void> clearRefreshToken() async {
    await _flutterSecureStorage.delete(key: _refreshTokenKey);
  }
}
