part of 'p_feed_tab.dart';

class _FeedTabScreen extends StatelessWidget {
  const _FeedTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      DisplayPostsBloc,
      DisplayState<FeedPostEntityWithAuthor>
    >(
      builder: (context, state) {
        return Scaffold(
          body: ListView.separated(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              return _FeedItemWidget(state.items[index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Divider(),
              );
            },
          ),
        );
      },
    );
  }
}
