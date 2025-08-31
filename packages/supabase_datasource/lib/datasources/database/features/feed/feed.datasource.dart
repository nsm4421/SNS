part of 'feed.datasource_impl.dart';

abstract interface class FeedDataSource {
  FeedPostDataSource get post;

  FeedPostImageDataSource get image;

  FeedPostLikeDataSource get like;

  FeedPostCommentDataSource get comment;
}
