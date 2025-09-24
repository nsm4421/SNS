import 'package:injectable/injectable.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/auth/auth_datasource.dart';
import 'package:supabase_datasource/src/db/profiles/profiles_table.datasource.dart';
import 'package:supabase_datasource/src/env/env.dart';

@module
abstract class SupabaseModule {
  final SupabaseClient _client = SupabaseClient(
    Env.supabaseUrl,
    Env.supabaseAnonKey,
  );

  @lazySingleton
  AuthDatasource get auth => SupabaseAuthDataSourceImpl(_client.auth);

  @lazySingleton
  ProfilesTableDataSource get profileTable => SupabaseProfileTableDataSourceImpl(_client.rest.from('profiles'));
}
