part of 'secure_local_storage.datasource.dart';

class SecureLocalStorageDataSourceImpl implements SecureLocalStorageDataSource {
  SecureLocalStorageDataSourceImpl(this._flutterSecureStorage);

  final FlutterSecureStorage _flutterSecureStorage;

  @override
  Future<void> delete(String key) async {
    await _flutterSecureStorage.delete(key: key);
  }

  @override
  Future<String> read(String key) async {
    final fetched = await _flutterSecureStorage.read(key: key);
    if (fetched == null) {
      throw CustomException.localStorage(
        code: ErrorCode.notFound,
        message: 'key $key is not founded',
      );
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
      if (fetched == null) {
        throw CustomException.localStorage(
          code: ErrorCode.conflict,
          message: 'key $key is already in use',
        );
      }
    }
    await _flutterSecureStorage.write(key: key, value: value);
  }
}
