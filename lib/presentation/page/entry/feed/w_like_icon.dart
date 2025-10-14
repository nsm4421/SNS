part of 'p_feed_tab.dart';

class _LikeIconWidget extends StatelessWidget {
  const _LikeIconWidget(this._feed, {super.key});

  final FeedPostEntityWithAuthor _feed;

  static const double _iconSize = 16;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<ToggleLikeOnPostCubit>(param1: _feed),
      child: BlocBuilder<ToggleLikeOnPostCubit, ToggleLikeOnPostState>(
        builder: (context, state) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: state.isLoading
                    ? null
                    : () async {
                        await context.read<ToggleLikeOnPostCubit>().toggle();
                      },
                icon: Icon(
                  state.likedByMe ? Icons.favorite : Icons.favorite_border,
                  color: state.isLoading ? Colors.grey : Colors.blueGrey,
                  size: _iconSize,
                ),
              ),
              Text(
                state.likeCount.toString(),
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.blueGrey),
              ),
            ],
          );
        },
      ),
    );
  }
}
