import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:local_storage/local_storage.dart';

@module
abstract class LocalStorageDataSourceModule {
  final _flutterSecureStorage = FlutterSecureStorage();

  @lazySingleton
  SecureLocalStorageDataSource get secureLocalStorage =>
      SecureLocalStorageDataSourceImpl(_flutterSecureStorage);
}
