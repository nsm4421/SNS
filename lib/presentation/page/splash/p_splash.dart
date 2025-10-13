import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karma/presentation/provider/auth/auth.bloc.dart';
import 'package:karma/presentation/router/app_router.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final StreamSubscription<dynamic> _subscription;
  static const Duration _delay = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _subscription = context.read<AuthBloc>().stream.listen((state) {
      state.mapOrNull(
        authenticated: (_) async {
          await Future.delayed(_delay);
          if (!mounted) return;
          context.router.replaceAll([const EntryRoute()]);
        },
        unauthenticated: (_) async {
          await Future.delayed(_delay);
          if (!mounted) return;
          context.router.replaceAll([const SignInRoute()]);
        },
      );
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(0, -1),
            end: const Alignment(0, 1),
            colors: [
              Theme.of(context).colorScheme.primary.withAlpha(10),
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: Text(
            "KARMA",
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
