import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared/shared.dart';

part 'secure_local_storage.datasource_impl.dart';

abstract interface class SecureLocalStorageDataSource {
  Future<String> read(String key);

  Future<void> write({
    required String key,
    required String value,
    bool overwrite = true,
  });

  Future<void> delete(String key);
}
