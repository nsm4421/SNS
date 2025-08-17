import 'package:data/datasource/local_strage/local_storage.datasource_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'database/database.dart';
import 'features/auth/supabase_auth.datasource_impl.dart';
import 'features/auth/user_table.datasource_impl.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class DatabaseModule {
  final SupabaseClient _client = Supabase.instance.client;
  final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();
  final UsersTable _usersTable = UsersTable();

  @lazySingleton
  SupabaseAuthDataSource get auth => SupabaseAuthDataSourceImpl(_client);

  @lazySingleton
  UserTableDataSource get user => UserTableDataSourceImpl(_usersTable);

  @lazySingleton
  LocalStorageDataSource get localStorage =>
      LocalStorageDataSourceImpl(_flutterSecureStorage);
}
