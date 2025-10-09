import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

part 'local_token.datasource_impl.dart';

abstract interface class LocalTokenDataSource {
  Future<(String? accessToken, String? refreshToken)> getTokens();

  Future<String?> getRefreshToken();

  Future<void> saveTokens({String? accessToken, String? refreshToken});

  Future<void> clearTokens();
}
