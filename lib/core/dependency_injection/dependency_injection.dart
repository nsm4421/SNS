import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:local_storage/local_storage.dart';
import 'package:supabase_datasource/supabase_datasource.dart';

import 'dependency_injection.config.dart';

@InjectableInit(
  includeMicroPackages: true,
  externalPackageModulesBefore: [
    ExternalModule(SupabaseDatasourcePackageModule),
    ExternalModule(LocalStoragePackageModule),
  ],
)
Future<void> configureDependencies() async {
  await GetIt.instance.init();
}
