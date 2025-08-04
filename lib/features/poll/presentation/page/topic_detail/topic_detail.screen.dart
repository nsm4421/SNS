import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/poll/presentation/bloc/vote/vote.bloc.dart';

import 'cast_vote.fragment.dart';
import 'display_comments.fragment.dart';
import 'display_vote.fragment.dart';

class TopicDetailScreen extends StatelessWidget {
  const TopicDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Topic Detail")),
      body: BlocBuilder<VoteBloc, VoteState>(
        builder: (context, state) {
          return switch (state.status) {
            CastVoteStatus.idle => const SizedBox.shrink(),
            CastVoteStatus.unVoted => CastVoteFragment(state.topic!),
            CastVoteStatus.voted => Column(
              children: [
                DisplayVoteFragment(state.topic!),
                const DisplayCommentFragment(),
              ],
            ),
          };
        },
      ),
    );
  }
}
