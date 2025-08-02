import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/poll/domain/entity/topic.entity.dart';
import 'package:sns/features/poll/presentation/bloc/display_topics/display_topics.bloc.dart';
import 'display_topics.screen.dart';

class DisplayTopicPage extends StatelessWidget {
  const DisplayTopicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DisplayTopicBloc>()..add(RefreshDisplayEvent()),
      child: BlocListener<DisplayTopicBloc, SimpleDisplayState<TopicEntity>>(
        listener: (context, state) {
          if (state.status == DisplayStatus.error) {
            context.showErrorSnackBar(state.errorMessage ?? 'error occurs');
          }
        },
        child: const DisplayTopicScreen(),
      ),
    );
  }
}
