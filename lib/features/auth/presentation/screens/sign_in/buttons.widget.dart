import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/router/app_router.dart';
import 'package:sns/core/util/bloc/simple_cubit.dart';
import 'package:sns/features/auth/presentation/bloc/sign_in/sign_in.cubit.dart';

class ButtonsWidget extends StatelessWidget {
  const ButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SimpleCubitState>(
      builder: (context, state) {
        final tappable = state.status == Status.initial;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: tappable
                    ? () async {
                        await context.read<SignInCubit>().handleSubmit();
                      }
                    : null,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("SUBMIT")],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: tappable
                    ? () {
                        context.router.pushPath(AppRoutes.signUp.path);
                      }
                    : null,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Sign Up")],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
