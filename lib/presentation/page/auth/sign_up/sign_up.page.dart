import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/dependency_injection/dependency_injection.dart';
import 'package:sns/core/extension/build_context.extension.dart';
import 'package:sns/core/util/bloc/simple_cubit.dart';
import 'package:sns/presentation/bloc/auth/sign_up/sign_up.cubit.dart';
import 'package:sns/presentation/route/app_routes.dart';
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
