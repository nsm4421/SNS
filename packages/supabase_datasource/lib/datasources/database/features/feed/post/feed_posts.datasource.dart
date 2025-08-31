part of 'feed_posts.datasource_impl.dart';

abstract mixin class FeedPostDataSource {
  Future<FeedPostsRow> createPost(CreateFeedPostRequestModel request);

  Future<FeedPostsWithCountsRow> getPostWithCountById(String postId);

  Future<Page<FeedPostsWithCountsRow>> fetchPosts({
    String? cursor,
    int limit = 20,
  });

  Future<void> deletePostById(String postId);
}
