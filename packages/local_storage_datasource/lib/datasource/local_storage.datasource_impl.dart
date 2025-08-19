import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_storage_datasource/datasource/local_storage.datasource.dart';
import 'package:response_wrapper/api_exception/api_exception.dart';

class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  LocalStorageDataSourceImpl(this._flutterSecureStorage);

  final FlutterSecureStorage _flutterSecureStorage;

  @override
  Future<void> delete(String key) async {
    await _flutterSecureStorage.delete(key: key);
  }

  @override
  Future<String> read(String key) async {
    final fetched = await _flutterSecureStorage.read(key: key);
    if (fetched == null) {
      throw ApiException.notFound('key $key is not found in local storage');
    }
    return fetched;
  }

  @override
  Future<void> write({
    required String key,
    required String value,
    bool overwrite = true,
  }) async {
    if (!overwrite) {
      final fetched = await _flutterSecureStorage.read(key: key);
      if (fetched != null) {
        throw ApiException.conflict(
          'key $key is already used in local storage',
        );
      }
    }
    await _flutterSecureStorage.write(key: key, value: value);
  }
}
