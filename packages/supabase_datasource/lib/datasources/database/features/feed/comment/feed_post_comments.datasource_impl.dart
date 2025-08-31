import 'package:shared/pagination/page.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';
import 'package:supabase_datasource/datasources/model/feed/comment/create_post_comment_request.model.dart';

part 'feed_post_comments.datasource.dart';

class FeedPostCommentDataSourceImpl implements FeedPostCommentDataSource {
  FeedPostCommentDataSourceImpl({
    required FeedPostCommentsTable feedPostCommentsTable,
    required FeedWithImagesAndCountsTable feedWithImagesWithCountsTable,
  }) : _feedPostCommentsTable = feedPostCommentsTable,
       _feedWithImagesWithCountsTable = feedWithImagesWithCountsTable;

  final FeedPostCommentsTable _feedPostCommentsTable;
  final FeedWithImagesAndCountsTable _feedWithImagesWithCountsTable;

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
  Future<Page<FeedPostCommentsRow>> fetchChildComments({
    required String postId,
    required String parentId,
    int limit = 20,
    String? cursor,
  }) {
    return _feedPostCommentsTable
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
                : res.first.createdAt.toUtc().toString(),
          );
        });
  }

  @override
  Future<Page<FeedPostCommentsRow>> fetchParentComments({
    required String postId,
    int limit = 20,
    String? cursor,
  }) async {
    return _feedPostCommentsTable
        .queryRows(
          queryFn: (q) => q
              .eq('post_id', postId)
              .isFilter('parent_id', null)
              .lt('created_at', cursor ?? DateTime.now().toUtc())
              .order('created_at'),
        )
        .then((res) {
          return Page(
            items: res,
            nextCursor: res.length < limit
                ? null
                : res.first.createdAt.toUtc().toString(),
          );
        });
  }

  @override
  Future<int> getCommentCount(String postId) async {
    return _feedWithImagesWithCountsTable
        .querySingleRow(queryFn: (q) => q.eq('post_id', postId))
        .then((res) => res?.commentsCount ?? 0);
  }
}
