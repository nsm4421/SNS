import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karma/core/extension/build_context.extension.dart';
import 'package:karma/presentation/provider/auth/auth.bloc.dart';
import 'package:karma/presentation/router/app_router.dart' show SignInRoute;

part 'sign_up.screen.dart';

@RoutePage()
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          failure: (fail) {
            debugPrint(fail.repr);
            context.showErrorSnackBar(fail.message);
          },
          orElse: () {},
        );
      },
      child: const _SignUpScreen(),
    );
  }
}
