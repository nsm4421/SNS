import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karma/presentation/provider/auth/auth.bloc.dart';
import 'package:karma/presentation/router/app_router.dart' show SignInRoute;

class SignOutIconButtonWidget extends StatelessWidget {
  const SignOutIconButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return IconButton(
          onPressed: state.isAuth
              ? () async {
                  context.read<AuthBloc>().add(
                    const AuthEvent.signOutRequested(),
                  );
                  await context.router.replace(const SignInRoute());
                }
              : null,
          icon: const Icon(Icons.login_outlined),
        );
      },
    );
  }
}
