import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:karma/core/extension/build_context.extension.dart';
import 'package:karma/domain/usecase/usecase.export.dart';
import 'package:karma/presentation/provider/auth/auth.bloc.dart';
import 'package:karma/presentation/router/app_router.dart'
    show SignInRoute, EntryRoute;

part 'sign_up.screen.dart';

part 'username_text_field.widget.dart';

@RoutePage()
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (user) {
            context.router.replaceAll([const EntryRoute()]);
          },
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
