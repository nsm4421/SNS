import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/poll/presentation/bloc/create_topic/create_topic.cubit.dart';
import 'create_topic.screen.dart';

class CreateTopicPage extends StatelessWidget {
  const CreateTopicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateTopicCubit>(),
      child: BlocListener<CreateTopicCubit, SimpleCubitState<CreateTopicData>>(
        listener: (context, state) {
          if (state.status == Status.error) {
            context.showErrorSnackBar(state.errorMessage ?? 'error occurs');
          } else if (state.status == Status.success) {
            context.showSuccessSnackBar('success');
            if (context.canPop()) {
              context.pop();
            }
          }
        },
        child: const CreateTopicScreen(),
      ),
    );
  }
}
