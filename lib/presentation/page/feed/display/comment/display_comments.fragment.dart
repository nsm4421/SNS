part of '../display_posts.page.dart';

class DisplayCommentsFragment extends StatefulWidget {
  const DisplayCommentsFragment({super.key});

  @override
  State<DisplayCommentsFragment> createState() =>
      _DisplayCommentsFragmentState();
}

class _DisplayCommentsFragmentState extends State<DisplayCommentsFragment> {
  late final ScrollController _scrollController;
  static const double _preloadOffset = 100;
  static const double _avatarSize = 36;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        context.read<DisplayParentCommentBloc>().state.nextCursor == null ||
        context.read<DisplayParentCommentBloc>().state.status !=
            DisplayStatus.loaded) {
      return;
    }
    final threshold =
        _scrollController.position.maxScrollExtent - _preloadOffset;
    if (_scrollController.position.pixels < threshold) return;
    context.read<DisplayParentCommentBloc>().add(FetchDisplayDataEvent());
  }

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
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: state.data.length,
          itemBuilder: (context, index) {
            final item = state.data[index];
            return Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO : 프로필사진
                    const CircleAvatar(radius: _avatarSize / 2),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                item.creator.username,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              if (item.createdAt != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    item.createdAt!.toKoTimeFormat,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ExpandableTextWidget(text: item.content),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // 댓글 신고하기 기능
                      },
                      icon: Icon(
                        Icons.more_vert,
                        size: _avatarSize / 2,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
