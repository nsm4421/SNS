import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:local_storage_datasource/datasource/local_storage.datasource.dart';
import 'package:sns/data/datasource/auth/auth.datasource_impl.dart';
import 'package:sns/data/datasource/feed/feed_storage.dastasource_impl.dart';
import 'package:supabase_datasource/datasources/auth/auth.datasource_impl.dart';
import 'package:supabase_datasource/datasources/storage/storage.datasource_impl.dart';

@module
abstract class AppDataSourceModule {
  final SupabaseAuthDataSource _supabaseAuthDataSource =
      GetIt.instance<SupabaseAuthDataSource>();
  final SupabaseStorageDataSource _supabaseStorageDataSource =
      GetIt.instance<SupabaseStorageDataSource>();
  final _localStorageDataSource = GetIt.instance<LocalStorageDataSource>();

  @lazySingleton
  AuthDataSource get auth => AuthDataSourceImpl(
    supabaseAuthDataSource: _supabaseAuthDataSource,
    localStorageDataSource: _localStorageDataSource,
  );

  @lazySingleton
  FeedStorageDataSource get feedStorage =>
      FeedStorageDataSourceImpl(_supabaseStorageDataSource);
}
