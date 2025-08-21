import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/presentation/provider/auth/authentication/authentication.bloc.dart';

class SignOutButtonWidget extends StatelessWidget {
  const SignOutButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        context.read<AuthenticationBloc>().add(SignOutEvent());
      },
      icon: const Icon(Icons.logout_outlined),
    );
  }
}
