import 'package:karma/core/core.export.dart';
import 'package:karma/data/datasource/db/db_error_handler_mixin.dart';
import 'package:karma/data/model/model.export.dart';
import 'package:logger/logger.dart';
import 'package:supabase/supabase.dart';

import '../generated/database.dart';

part 'feed_tables.datasource_impl.dart';

abstract interface class FeedTablesDataSource {
  // ───── posts ─────
  Future<FeedPostsRow> createPost(CreatePostRequestDto dto);

  Future<FeedPostsRow> getPostById(String postId);

  Future<Iterable<VFeedListRow>> fetchFeedList({
    required String cursor, // createdAt
    int limit = 30,
  });

  Future<void> updatePost(UpdatePostRequestDto dto);

  Future<void> deletePost(String postId, {bool isSoft = true});

  // ───── likes ─────
  Future<FeedPostLikesRow?> findPostLike(String postId);

  // ───── comments ─────
  Future<FeedCommentsRow> addComment(CreateCommentRequestDto dto);

  Future<Pageable<VFeedCommentListRow>> fetchComments({
    required String postId,
    required String cursor, // created_at
    int limit = 30,
    bool ascending = true, // 타임라인 정렬 방향
  });

  Future<void> deleteComment(String commentId, {bool isSoft = true});

  // ───── media ─────
  Future<FeedMediaRow> insertMedia(InsertMediaRequestDto dto);

  Future<Iterable<FeedMediaRow>> getMedias(String postId);

  Future<void> deleteMedia(String mediaId);

  Future<void> reorderMedias(ReorderMediaRequestDto dto);
}
