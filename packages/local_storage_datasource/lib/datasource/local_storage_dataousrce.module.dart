import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:local_storage_datasource/export.dart';

@module
abstract class LocalStorageDataSourceModule {
  final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();

  LocalStorageDataSource get localStorage =>
      LocalStorageDataSourceImpl(_flutterSecureStorage);
}
