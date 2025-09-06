part of '../display_posts.page.dart';

class DisplayCommentsFragment extends StatelessWidget {
  const DisplayCommentsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      DisplayParentCommentBloc,
      SimpleDisplayState<ParentPostCommentEntity>
    >(
      builder: (context, state) {
        if (state.data.isEmpty) {
          return const Center(child: Text("등록된 댓글이 없습니다"));
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: state.data.length,
          itemBuilder: (context, index) {
            final item = state.data[index];
            return ListTile(
              title: Text(item.content),
              subtitle: item.createdAt == null
                  ? null
                  : Text(item.createdAt!.toLocal().toString()),
            );
          },
        );
      },
    );
  }
}
