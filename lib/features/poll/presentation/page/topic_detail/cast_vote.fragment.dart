import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/features/poll/domain/entity/option.entity.dart';
import 'package:sns/features/poll/domain/entity/topic_detail.entity.dart';
import 'package:sns/features/poll/presentation/bloc/vote/vote.bloc.dart';

class CastVoteFragment extends StatefulWidget {
  const CastVoteFragment(this._topic, {super.key});

  final TopicDetailEntity _topic;

  @override
  State<CastVoteFragment> createState() => _CastVoteFragmentState();
}

class _CastVoteFragmentState extends State<CastVoteFragment> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget._topic.options.length,
          itemBuilder: (context, index) {
            final option = widget._topic.options[index];
            return ListTile(
              onTap: () {
                setState(() {
                  _current = index;
                });
              },
              leading: index == _current
                  ? const Icon(Icons.check_circle_outline)
                  : const Icon(Icons.circle_outlined),
              title: Text(option.content),
            );
          },
        ),
        BlocBuilder<VoteBloc, VoteState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      context.read<VoteBloc>().add(
                        CastVoteEvent(widget._topic.options[_current]),
                      );
                    },
              child: const Text("VOTE"),
            );
          },
        ),
      ],
    );
  }
}
