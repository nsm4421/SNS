import 'package:injectable/injectable.dart';
import 'package:supabase_datasource/datasources/auth/auth.datasource.dart';
import 'package:supabase_datasource/datasources/auth/auth.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';
import 'package:supabase_datasource/datasources/database/user/user_table.datasource.dart';
import 'package:supabase_datasource/datasources/database/user/user_table.datasource_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class SupabaeDataSourceModule {
  final SupabaseClient _client = Supabase.instance.client;
  final UsersTable _usersTable = UsersTable();

  SupabaseAuthDataSource get auth => SupabaseAuthDataSourceImpl(_client.auth);

  UserTableDataSource get userTable => UserTableDataSourceImpl(_usersTable);
}
