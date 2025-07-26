import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/features/auth/data/datasource/local/local_session.datasource_impl.dart';
import 'package:sns/features/auth/data/datasource/remote/remote_auth.datasource_impl.dart';
import 'package:sns/features/auth/data/datasource/remote/remote_user.datasource_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class DataSourceModule {
  final FlutterSecureStorage _flutterSecureStorage =
      const FlutterSecureStorage();

  final SupabaseClient _supabaseClient = Supabase.instance.client;

  @lazySingleton
  RemoteAuthDataSource get remoteAuth =>
      RemoteAuthDataSourceImpl(_supabaseClient.auth);

  @lazySingleton
  RemoteUserDataSource get remoteUser =>
      RemoteUserDataSourceImpl(_supabaseClient.rest.from('users'));

  @lazySingleton
  LocalSessionDataSource get localSession =>
      LocalSessionDataSourceImpl(_flutterSecureStorage);
}
