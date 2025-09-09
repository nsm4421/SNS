part of '../display_posts.page.dart';

class PostLikeIconWidget extends StatelessWidget {
  const PostLikeIconWidget(this._post, {super.key, double iconSize = 18})
    : _iconSize = iconSize;

  final PostEntity _post;
  final double _iconSize;

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
                    isSelected: state.likedByMe,
                    icon: Icon(Icons.favorite_border, size: _iconSize),
                    selectedIcon: Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.primary,
                      size: _iconSize,
                    ),
                  ),
                  Text(
                    state.likesCount.toString(),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
