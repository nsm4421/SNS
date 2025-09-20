import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'core/dependency_injection/dependency_injection.dart';
import 'core/theme/theme_data/app_theme_data.dart'
    show LightAppThemeData, DarkAppThemeData;
import 'presentation/router/app_router.dart' show AppRouter;

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
    return MaterialApp.router(
      title: 'Alarm App',
      theme: GetIt.instance<LightAppThemeData>().themeData,
      darkTheme: GetIt.instance<DarkAppThemeData>().themeData,
      routerConfig: GetIt.instance<AppRouter>().config(),
    );
  }
}
