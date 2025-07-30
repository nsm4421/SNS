import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/util/bloc/simple_cubit.dart';
import 'package:sns/features/poll/presentation/bloc/create_topic.cubit.dart';

class SubmitButtonWidget extends StatelessWidget {
  const SubmitButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTopicCubit, SimpleCubitState<CreateTopicData>>(
      builder: (context, state) {
        return IconButton(
          onPressed: () async {
            if (state.status != Status.initial) {
              return;
            }
            FocusScope.of(context).unfocus();
            await context.read<CreateTopicCubit>().submit();
          },
          tooltip: 'SUBMIT',
          icon: Icon(
            Icons.add_circle_outline,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
