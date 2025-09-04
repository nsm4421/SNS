part of 'display_feed.page.dart';

class LikePostIconWidget extends StatelessWidget {
  const LikePostIconWidget(this._feed, {super.key});

  final PostEntity _feed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<LikePostCubit>(param1: _feed),
      child: BlocBuilder<LikePostCubit, LikePostState>(
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
              const SizedBox(width: 12),
              Text(state.likesCount.toString()),
            ],
          );
        },
      ),
    );
  }
}
