import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/core/dependency_injection/dependency_injection.dart';
import 'package:sns/presentation/bloc/auth/authentication/authentication.bloc.dart';
import 'package:sns/presentation/route/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/env/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);

  configureDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthenticationBloc>()..add(AppStartedEvent()),
      child: MaterialApp(
        title: 'Karma',
        theme: ThemeData.dark(useMaterial3: true),
        home: MaterialApp.router(
          routerConfig: getIt<AppRouter>().routeConfig,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
