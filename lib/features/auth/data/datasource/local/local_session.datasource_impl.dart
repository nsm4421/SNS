import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sns/core/response/datasource_response_wrapper_mixin.dart';

part 'local_session.datasource.dart';

class LocalSessionDataSourceImpl
    with DataSourceResponseWrapperMixIn
    implements LocalSessionDataSource {
  final FlutterSecureStorage _flutterSecureStorage;

  LocalSessionDataSourceImpl(this._flutterSecureStorage);

  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  @override
  Future<String?> getAccessToken() async => await guardApi<String?>(() async {
    return await _flutterSecureStorage.read(key: _accessTokenKey);
  });

  @override
  Future<String?> getRefreshToken() async => await guardApi<String?>(() async {
    return await _flutterSecureStorage.read(key: _refreshTokenKey);
  });

  @override
  Future<void> setAccessToken(String token) async =>
      await guardApi<void>(() async {
        await _flutterSecureStorage.write(key: _accessTokenKey, value: token);
      });

  @override
  Future<void> setRefreshToken(String token) async =>
      await guardApi<void>(() async {
        await _flutterSecureStorage.write(key: _refreshTokenKey, value: token);
      });

  @override
  Future<void> clearAccessToken() async => await guardApi<void>(() async {
    await _flutterSecureStorage.delete(key: _accessTokenKey);
  });

  @override
  Future<void> clearRefreshToken() async => await guardApi<void>(() async {
    await _flutterSecureStorage.delete(key: _refreshTokenKey);
  });
}
