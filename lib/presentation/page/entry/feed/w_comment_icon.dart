part of 'p_feed_tab.dart';

class _CommentIconWidget extends StatefulWidget {
  const _CommentIconWidget(this._feed, {super.key});

  final FeedPostEntityWithAuthor _feed;

  @override
  State<_CommentIconWidget> createState() => _CommentIconWidgetState();
}

class _CommentIconWidgetState extends State<_CommentIconWidget> {
  late int _commentCount;
  static const int _duration = 300;
  static const double _iconSize = 16;

  @override
  void initState() {
    super.initState();
    _commentCount = widget._feed.commentCount;
  }

  _handleNavigateToCommentScreen() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.95,
      ),
      showDragHandle: true,
      builder: (context) {
        return const _FeedCommentScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _handleNavigateToCommentScreen,
          icon: const Icon(
            Icons.comment_outlined,
            size: _iconSize,
            color: Colors.blueGrey,
          ),
        ),
        Text(
          _commentCount.toString(),
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: Colors.blueGrey),
        ),
      ],
    );
  }
}
