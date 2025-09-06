part of '../display_posts.page.dart';

class PostLikeIconWidget extends StatelessWidget {
  const PostLikeIconWidget(this._post, {super.key});

  final PostEntity _post;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<LikePostCubit>(param1: _post),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 좋아요 아이콘
          BlocBuilder<LikePostCubit, LikePostState>(
            builder: (context, state) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: state.tappable
                        ? context.read<LikePostCubit>().handleToggle
                        : null,
                    icon: state.likedByMe
                        ? Icon(
                            Icons.favorite,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : const Icon(Icons.favorite_border),
                  ),
                  const SizedBox(width: 8),
                  Text(state.likesCount.toString()),
                ],
              );
            },
          ),

          // 댓글 아이콘

        ],
      ),
    );
  }
}
