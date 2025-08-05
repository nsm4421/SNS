import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/comment/comment.export.dart';
import 'package:sns/features/poll/presentation/bloc/vote/vote.bloc.dart';
import 'topic_detail.screen.dart';

class TopicDetailPage extends StatelessWidget {
  const TopicDetailPage(this._topicId, {super.key});

  final String _topicId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<DisplayTopicCommentsBloc>(param1: _topicId)
                ..add(RefreshDisplayEvent()),
        ),
        BlocProvider(
          create: (_) => getIt<CreateTopicCommentCubit>(param1: _topicId),
        ),
        BlocProvider(
          create: (_) =>
              getIt<VoteBloc>(param1: _topicId)..add(MountVoteEvent()),
        ),
      ],
      child: BlocListener<VoteBloc, VoteState>(
        listenWhen: (prev, curr) =>
            (prev.errorMessage == null) && (curr.errorMessage != null),
        listener: (context, state) {
          context.showErrorSnackBar(state.errorMessage ?? 'error occurs');
        },
        child: const TopicDetailScreen(),
      ),
    );
  }
}
