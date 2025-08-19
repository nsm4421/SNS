import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:local_storage_datasource/dependency_injection/dependency_injection.module.dart'
    as local_storage_datasource_di;
import 'package:supabase_datasource/core/dependency_injection.module.dart'
    as supabase_datasource_di;

import 'dependency_injection.config.dart';

@InjectableInit(
  includeMicroPackages: true,
  externalPackageModulesBefore: [
    ExternalModule(supabase_datasource_di.SupabaseDatasourcePackageModule),
    ExternalModule(
      local_storage_datasource_di.LocalStorageDatasourcePackageModule,
    ),
  ],
)
Future<void> configureDependencies() async {
  await GetIt.instance.init();
}
