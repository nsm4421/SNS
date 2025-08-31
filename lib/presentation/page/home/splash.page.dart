import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/constant/auth_status.constant.dart';
import 'package:sns/presentation/provider/auth/authentication/authentication.bloc.dart';
import 'package:sns/presentation/router/app_router.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final StreamSubscription<AuthStatus> _streamSubscription;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _streamSubscription = context
        .read<AuthenticationBloc>()
        .authStatusStream
        .listen((e) async {
          if (e == AuthStatus.checking) return;
          await Future.delayed(const Duration(seconds: 2));
          _streamSubscription.cancel();
          context.replaceRoute(
            e == AuthStatus.authenticated
                ? const HomeRoute()
                : const SignInRoute(),
          );
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
          child: Center(
            child: Text(
              'Karma',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
