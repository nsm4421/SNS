part of 'go_true_async_storage.datasource.dart';

class GoTrueAsyncStorageDataSourceImpl implements GoTrueAsyncStorageDataSource {
  const GoTrueAsyncStorageDataSourceImpl(
    this._flutterSecureStorage,
  );

  final FlutterSecureStorage _flutterSecureStorage;

  @override
  Future<String?> getItem({required String key}) async {
    return _flutterSecureStorage.read(key: key);
  }

  @override
  Future<void> setItem({required String key, required String value}) async {
    await _flutterSecureStorage.write(key: key, value: value);
  }

  @override
  Future<void> removeItem({required String key}) async {
    await _flutterSecureStorage.delete(key: key);
  }
}
