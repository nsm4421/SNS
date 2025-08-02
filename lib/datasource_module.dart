import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/features/auth/auth.export.dart';
import 'package:sns/features/poll/poll.export.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class DataSourceModule {
  final FlutterSecureStorage _flutterSecureStorage =
      const FlutterSecureStorage();

  final SupabaseClient _supabaseClient = Supabase.instance.client;

  @lazySingleton
  RemoteAuthDataSource get remoteAuth =>
      RemoteAuthDataSourceImpl(_supabaseClient);

  @lazySingleton
  RemoteUserDataSource get remoteUser =>
      RemoteUserDataSourceImpl(_supabaseClient);

  @lazySingleton
  LocalSessionDataSource get localStorage =>
      LocalSessionDataSourceImpl(_flutterSecureStorage);

  @lazySingleton
  RemotePollDataSource get remotePoll =>
      RemotePollDataSourceImpl(_supabaseClient);
}
