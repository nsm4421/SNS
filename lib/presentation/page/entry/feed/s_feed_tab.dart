part of 'p_feed_tab.dart';

class _FeedTabScreen extends StatefulWidget {
  const _FeedTabScreen({super.key});

  @override
  State<_FeedTabScreen> createState() => _FeedTabScreenState();
}

class _FeedTabScreenState extends State<_FeedTabScreen> {
  late final ScrollController _scrollController;
  static const double _scrollThreshold = 300;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients ||
        _scrollController.position.extentAfter >= _scrollThreshold) {
      return;
    }
    debugPrint('fetch more page');
    context.read<DisplayPostsBloc>().add(
      const DisplayEvent<FeedPostEntityWithAuthor>.nextPageRequested(),
    );
  }

  Future<void> _onRefresh() async {
    context.read<DisplayPostsBloc>().add(
      const DisplayEvent<FeedPostEntityWithAuthor>.refreshed(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      DisplayPostsBloc,
      DisplayState<FeedPostEntityWithAuthor>
    >(
      builder: (context, state) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            edgeOffset: 20,
            child: Column(
              children: [
                if (state.status == DisplayStatus.loading)
                  const CircularProgressIndicator(),
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      return _FeedItemWidget(state.items[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Divider(),
                      );
                    },
                  ),
                ),
                if (state.status == DisplayStatus.paginated)
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
