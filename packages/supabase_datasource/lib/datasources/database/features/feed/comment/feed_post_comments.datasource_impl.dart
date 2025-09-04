import 'package:shared/pagination/page.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';
import 'package:supabase_datasource/datasources/model/feed/comment/create_post_comment_request.model.dart';

part 'feed_post_comments.datasource.dart';

class FeedPostCommentDataSourceImpl implements FeedPostCommentDataSource {
  FeedPostCommentDataSourceImpl({
    required FeedPostCommentsTable feedPostCommentsTable,
    required FeedWithImagesAndCountsTable feedWithImagesWithCountsTable,
    required FeedPostCommentsWithAuthorTable feedCommentsWithAuthorTable,
  }) : _feedPostCommentsTable = feedPostCommentsTable,
       _feedWithImagesWithCountsTable = feedWithImagesWithCountsTable,
       _feedPostCommentsWithAuthorTable = feedCommentsWithAuthorTable;

  final FeedPostCommentsTable _feedPostCommentsTable;
  final FeedWithImagesAndCountsTable _feedWithImagesWithCountsTable;
  final FeedPostCommentsWithAuthorTable _feedPostCommentsWithAuthorTable;

  @override
  Future<FeedPostCommentsRow> createParentComment(
    CreatePostParentCommentRequestModel request,
  ) async {
    return _feedPostCommentsTable.insert(request.toJson());
  }

  @override
  Future<FeedPostCommentsRow> createChildComment(
    CreatePostChildCommentRequestModel request,
  ) async {
    return _feedPostCommentsTable.insert(request.toJson());
  }

  @override
  Future<void> deleteCommentById(String commentId) async {
    await _feedPostCommentsTable.delete(
      matchingRows: (q) => q.eq('id', commentId),
    );
  }

  @override
  Future<Page<FeedPostCommentsWithAuthorRow>> fetchChildComments({
    required String postId,
    required String parentId,
    int limit = 20,
    String? cursor,
  }) {
    return _feedPostCommentsWithAuthorTable
        .queryRows(
          queryFn: (q) => q
              .eq('post_id', postId)
              .eq('parent_id', parentId)
              .lt('created_at', cursor ?? DateTime.now().toUtc())
              .order('created_at'),
        )
        .then((res) {
          return Page(
            items: res,
            nextCursor: res.length < limit
                ? null
                : res.first.createdAt!.toUtc().toString(),
          );
        });
  }

  @override
  Future<Page<FeedPostCommentsWithAuthorRow>> fetchParentComments({
    required String postId,
    int limit = 20,
    String? cursor,
  }) async {
    return _feedPostCommentsWithAuthorTable
        .queryRows(
          queryFn: (q) => q
              .eq('post_id', postId)
              .lt('created_at', cursor ?? DateTime.now().toUtc())
              .order('created_at'),
        )
        .then((res) {
          return Page(
            items: res,
            nextCursor: res.length < limit
                ? null
                : res.first.createdAt!.toUtc().toString(),
          );
        });
  }

  @Deprecated('use comments count field on feed_posts table instead')
  @override
  Future<int> getCommentCount(String postId) async {
    return _feedWithImagesWithCountsTable
        .querySingleRow(queryFn: (q) => q.eq('post_id', postId))
        .then((res) => res?.commentsCount ?? 0);
  }
}
