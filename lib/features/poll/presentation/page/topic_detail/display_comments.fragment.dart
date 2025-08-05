import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/comment/comment.export.dart';
import 'package:sns/features/comment/domain/entity/topic/topic_comment.entity.dart';

class DisplayCommentFragment extends StatelessWidget {
  const DisplayCommentFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("COMMENTS"),
        BlocBuilder<
          DisplayTopicCommentsBloc,
          SimpleDisplayState<TopicCommentEntity>
        >(
          builder: (context, state) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 3,
              ),
              child: Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    final comment = state.data[index];
                    return ListTile(title: Text(comment.content));
                  },
                  separatorBuilder: (_, __) {
                    return const Divider();
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
