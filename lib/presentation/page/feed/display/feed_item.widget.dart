part of 'display_posts.page.dart';

class FeedItemWidget extends StatefulWidget {
  const FeedItemWidget(this._post, {super.key});

  final PostEntity _post;

  @override
  State<FeedItemWidget> createState() => _FeedItemWidgetState();
}

class _FeedItemWidgetState extends State<FeedItemWidget> {
  static const double _avatarSize = 36;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TODO : 프로필 이미지
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: CircleAvatar(radius: _avatarSize / 2),
              ),
              const SizedBox(width: 8),
              Text(
                widget._post.creator.username,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // TODO : 신고버튼
                },
                icon: const Icon(Icons.more_vert),
                tooltip: '더보기',
              ),
            ],
          ),
        ),

        if (widget._post.images.isNotEmpty)
          NetworkImageCarouselWidget(widget._post.images),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: double.infinity,
                child: ExpandableTextWidget(text: widget._post.content),
              ),
            ),
          ),
        ),
        // 좋아요, 댓글 아이콘
        Row(
          children: [
            PostLikeIconWidget(widget._post),
            const SizedBox(width: 18),
            PostCommentIconWidget(widget._post),
          ],
        ),
      ],
    );
  }
}
