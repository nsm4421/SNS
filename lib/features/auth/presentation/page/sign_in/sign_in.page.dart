import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/util/dependency_injection/dependency_injection.dart';
import 'package:sns/core/util/extension/build_context.extension.dart';
import 'package:sns/core/util/bloc/simple_cubit.dart';
import 'package:sns/features/auth/presentation/bloc/sign_in/sign_in.cubit.dart';
import 'sign_in.screen.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignInCubit>(),
      child: BlocListener<SignInCubit, SimpleCubitState>(
        listener: (context, state) {
          if (state.status == Status.success) {
            context.showSuccessSnackBar('sign in success');
          } else if (state.status == Status.error) {
            context.showErrorSnackBar(state.errorMessage ?? 'sign in fail');
          }
        },
        child: const SignInScreen(),
      ),
    );
  }
}
