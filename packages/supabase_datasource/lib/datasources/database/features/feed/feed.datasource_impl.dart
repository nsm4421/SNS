import 'package:supabase_datasource/datasources/database/features/feed/comment/feed_post_comments.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/features/feed/image/feed_post_images.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/features/feed/like/feed_post_likes.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/features/feed/post/feed_posts.datasource_impl.dart';

part 'feed.datasource.dart';

class FeedDataSourceImpl implements FeedDataSource {
  FeedDataSourceImpl({
    required FeedPostDataSource feedPostDataSource,
    required FeedPostLikeDataSource feedLikeDataSource,
    required FeedPostCommentDataSource feedCommentDataSource,
    required FeedPostImageDataSource feedPostImagesDataSource,
  }) : _feedPostDataSource = feedPostDataSource,
       _feedLikeDataSource = feedLikeDataSource,
       _feedCommentDataSource = feedCommentDataSource,
       _feedPostImagesDataSource = feedPostImagesDataSource;

  final FeedPostDataSource _feedPostDataSource;
  final FeedPostLikeDataSource _feedLikeDataSource;
  final FeedPostCommentDataSource _feedCommentDataSource;
  final FeedPostImageDataSource _feedPostImagesDataSource;

  @override
  FeedPostCommentDataSource get comment => _feedCommentDataSource;

  @override
  FeedPostImageDataSource get image => _feedPostImagesDataSource;

  @override
  FeedPostLikeDataSource get like => _feedLikeDataSource;

  @override
  FeedPostDataSource get post => _feedPostDataSource;
}
