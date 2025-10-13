import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/core.export.dart';
import 'presentation/provider/provider.export.dart';
import 'presentation/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 의존성 주입
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
        scaffoldMessengerKey: scaffoldMessengerKey,
      ),
    );
  }
}
