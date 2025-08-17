part of 'local_storage.datasource_impl.dart';

abstract interface class LocalStorageDataSource {
  Future<String> read(String key);

  Future<void> write({
    required String key,
    required String value,
    bool overwrite = true,
  });

  Future<void> delete(String key);
}
