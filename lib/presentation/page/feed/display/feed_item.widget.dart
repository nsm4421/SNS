part of 'display_posts.page.dart';

class FeedItemWidget extends StatelessWidget {
  const FeedItemWidget(this._post, {super.key});

  final PostEntity _post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 작성자 정보
        Row(
          children: [
            Text(
              _post.creator.username,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
          ],
        ),

        // 이미지 carousel
        if (_post.images.isNotEmpty) FeedImageCarouselWidget(_post),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            _post.content,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),

        // 좋아요, 댓글 아이콘
        Row(
          children: [PostLikeIconWidget(_post), PostCommentIconWidget(_post)],
        ),
      ],
    );
  }
}
