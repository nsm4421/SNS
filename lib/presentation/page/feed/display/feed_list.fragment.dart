part of 'display_feed.page.dart';

class FeedListFragment extends StatelessWidget {
  const FeedListFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayPostBloc, SimpleDisplayState<PostEntity>>(
      builder: (context, state) {
        if (state.data.isEmpty) {
          return const Text('Nothing Fetched');
        }
        return ListView.separated(
          shrinkWrap: true,
          itemCount: state.data.length,
          itemBuilder: (context, index) {
            return FeedItemWidget(state.data[index]);
          },
          separatorBuilder: (_, __) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Divider(),
            );
          },
        );
      },
    );
  }
}
