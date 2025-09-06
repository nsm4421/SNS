part of '../display_posts.page.dart';

class PostCommentIconWidget extends StatelessWidget {
  const PostCommentIconWidget(this._post, {super.key});

  final PostEntity _post;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () async {
            await showModalBottomSheet<int?>(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              builder: (context) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) =>
                          GetIt.instance<CreateParentPostCommentCubit>(
                            param1: _post,
                          ),
                    ),
                    BlocProvider(
                      create: (_) => GetIt.instance<DisplayParentCommentBloc>(
                        param1: _post,
                      )..add(RefreshDisplayEvent()),
                    ),
                  ],
                  child: const PostCommentScreen(),
                );
              },
            ).then((res) {
              if (res == null || res == 0 || !context.mounted) return;
              context.read<DisplayPostsBloc>().add(
                UpdatePostCommentsCountEvent(postId: _post.id, delta: res),
              );
            });
          },
          icon: const Icon(Icons.comment_outlined),
        ),
        const SizedBox(width: 8),
        Text(_post.commentsCount.toString()),
      ],
    );
  }
}
