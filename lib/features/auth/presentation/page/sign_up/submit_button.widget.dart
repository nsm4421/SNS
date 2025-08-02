import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/auth/presentation/bloc/sign_up/sign_up.cubit.dart';

class SubmitButtonWidget extends StatelessWidget {
  const SubmitButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SimpleCubitState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            onPressed: state.status == Status.initial
                ? () async {
                    await context.read<SignUpCubit>().handleSubmit();
                  }
                : null,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("SUBMIT")],
            ),
          ),
        );
      },
    );
  }
}
