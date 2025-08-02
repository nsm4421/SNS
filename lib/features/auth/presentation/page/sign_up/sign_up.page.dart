import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/auth/presentation/bloc/sign_up/sign_up.cubit.dart';
import 'sign_up.screen.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignUpCubit>(),
      child: BlocListener<SignUpCubit, SimpleCubitState>(
        listener: (context, state) {
          if (state.status == Status.success) {
            context.showSuccessSnackBar('sign up success');
            context.replace(AppRoutes.signIn.path);
          } else if (state.status == Status.error) {
            context.showErrorSnackBar(state.errorMessage ?? 'sign up fail');
          }
        },
        child: const SignUpScreen(),
      ),
    );
  }
}
