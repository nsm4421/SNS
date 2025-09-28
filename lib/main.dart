import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:karma/presentation/provider/auth/auth.bloc.dart';
import 'package:supabase_datasource/supabase_datasource.dart';
import 'package:local_storage/local_storage.dart';
import 'core/dependency_injection/dependency_injection.dart';
import 'core/theme/theme_data/app_theme_data.dart'
    show LightAppThemeData, DarkAppThemeData;
import 'presentation/router/app_router.dart' show AppRouter;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 의존성 주입
  await initSupabaseDataSourceMicroPackage();
  await initLocalStorageMicroPackage();
  await configureDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<AuthBloc>()..add(const AuthEvent.started()),
      child: MaterialApp.router(
        title: 'Karma App',
        theme: GetIt.instance<LightAppThemeData>().themeData,
        darkTheme: GetIt.instance<DarkAppThemeData>().themeData,
        routerConfig: GetIt.instance<AppRouter>().config(),
      ),
    );
  }
}
