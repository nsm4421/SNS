part of 'local_session.datasource_impl.dart';

abstract interface class LocalSessionDataSource {
  Future<void> setAccessToken(String token);

  Future<void> setRefreshToken(String token);

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> clearAccessToken();

  Future<void> clearRefreshToken();
}
