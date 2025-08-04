import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/features/poll/domain/entity/topic_detail.entity.dart';
import 'package:sns/features/poll/presentation/bloc/vote/vote.bloc.dart';

class DisplayVoteFragment extends StatelessWidget {
  const DisplayVoteFragment(this._topic, {super.key});

  final TopicDetailEntity _topic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: _topic.options.length,
          itemBuilder: (context, index) {
            final option = _topic.options[index];
            return ListTile(
              leading: option.votedByMe
                  ? const Icon(Icons.check)
                  : const SizedBox.shrink(),
              title: Text(option.content),
              trailing: Text(option.voteCount.toString()),
            );
          },
        ),
        BlocBuilder<VoteBloc, VoteState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      context.read<VoteBloc>().add(CancelVoteEvent());
                    },
              child: const Text("Reset"),
            );
          },
        ),
      ],
    );
  }
}
