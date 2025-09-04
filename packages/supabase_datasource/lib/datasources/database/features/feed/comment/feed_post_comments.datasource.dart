part of 'feed_post_comments.datasource_impl.dart';

abstract interface class FeedPostCommentDataSource {
  Future<FeedPostCommentsRow> createParentComment(
    CreatePostParentCommentRequestModel request,
  );

  Future<FeedPostCommentsRow> createChildComment(
    CreatePostChildCommentRequestModel request,
  );

  Future<Page<FeedPostCommentsWithAuthorRow>> fetchParentComments({
    required String postId,
    int limit = 20,
    String? cursor,
  });

  Future<Page<FeedPostCommentsWithAuthorRow>> fetchChildComments({
    required String postId,
    required String parentId,
    int limit = 20,
    String? cursor,
  });

  Future<void> deleteCommentById(String commentId);

  Future<int> getCommentCount(String postId);
}
