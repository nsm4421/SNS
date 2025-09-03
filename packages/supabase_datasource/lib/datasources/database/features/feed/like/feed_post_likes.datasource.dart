part of 'feed_post_likes.datasource_impl.dart';

abstract interface class FeedPostLikeDataSource {
  Future<int?> toggleLike(String postId);

  Future<bool> getIsLike(String postId);

  Future<int> getLikeCount(String postId);
}
