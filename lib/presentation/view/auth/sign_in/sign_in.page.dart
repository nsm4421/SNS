import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karma/presentation/provider/auth/auth.bloc.dart';
import 'package:karma/presentation/router/app_router.dart'
    show SignUpRoute, HomeRoute;

part 'sign_in.screen.dart';

@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (u) {
            debugPrint('sign in success');
            context.router.replace(const HomeRoute());
          },
          orElse: () {},
        );
      },
      child: const SignInScreen(),
    );
  }
}
