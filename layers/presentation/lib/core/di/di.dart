import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

@InjectableInit(includeMicroPackages: true)
Future<void> configureDependencies() async {
  await GetIt.instance.init();
}
