import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sns/core/theme/theme_data/app_theme_data.dart';
import 'package:sns/presentation/provider/auth/authentication/authentication.bloc.dart';
import 'package:sns/presentation/router/app_router.dart';
import 'package:sns/presentation/router/auth_listenable.dart';
import 'package:supabase_datasource/core/dependency_injection.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'core/dependency_injection/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 의존성 주입
  await initSupabaseDataSourceMicroPackage();
  await configureDependencies();

  // timeago 한국어 세팅
  timeago.setLocaleMessages('ko', timeago.KoMessages());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<AuthenticationBloc>()..add(AppStartedEvent()),
      child: MaterialApp.router(
        title: 'Karma',
        theme: GetIt.instance<LightAppThemeData>().themeData,
        darkTheme: GetIt.instance<DarkAppThemeData>().themeData,
        routerConfig: GetIt.instance<AppRouter>().config(
          reevaluateListenable: GetIt.instance<AuthListenable>(),
        ),
      ),
    );
  }
}
