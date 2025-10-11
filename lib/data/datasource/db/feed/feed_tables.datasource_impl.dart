part of 'feed_tables.datasource.dart';

class SupabaseFeedTablesDataSourceImpl
    with DbErrorHandlerMixin
    implements FeedTablesDataSource {
  final VFeedListTable _postView;
  final VFeedCommentListTable _commentView;
  final FeedPostsTable _postsTable;
  final FeedPostLikesTable _postLikesTable;
  final FeedCommentsTable _commentTable;
  final FeedMediaTable _mediaTable;
  final Logger? _logger;
  late final String _currentUserId;

  SupabaseFeedTablesDataSourceImpl({
    required SupabaseClient client,
    required VFeedListTable postView,
    required VFeedCommentListTable commentView,
    required FeedPostsTable postsTable,
    required FeedPostLikesTable postLikesTable,
    required FeedCommentsTable commentTable,
    required FeedMediaTable mediaTable,
    Logger? logger,
  }) : _postView = postView,
       _commentView = commentView,
       _postsTable = postsTable,
       _postLikesTable = postLikesTable,
       _commentTable = commentTable,
       _mediaTable = mediaTable,
       _logger = logger {
    _currentUserId = client.auth.currentUser!.id;
  }

  /// -──── posts ─────
  @override
  Future<FeedPostsRow> createPost(CreatePostRequestDto dto) async {
    try {
      return await _postsTable.insert({
        if (dto.clientPostId != null) 'id': dto.clientPostId,
        ...dto.toJson(),
        'visibility': tryParseFeedVisibility(dto.visibilityText),
      });
    } on PostgrestException catch (e, st) {
      _logger?.e('feed datsource error', error: e, stackTrace: st);
      throwCustomExceptionFromPostgresException(e);
    }
  }

  @override
  Future<FeedPostsRow> getPostById(String postId) async {
    try {
      final fetched = await _postsTable.querySingleRow(
        queryFn: (q) => q.eq('id', postId),
      );
      if (fetched == null) {
        throw CustomException.database(
          message: 'post not found',
          code: ErrorCode.notFound,
        );
      }
      return fetched;
    } on PostgrestException catch (e, st) {
      _logger?.e('feed datsource error', error: e, stackTrace: st);
      throwCustomExceptionFromPostgresException(e);
    }
  }

  @override
  Future<Pageable<VFeedListRow>> fetchFeedList({
    required String cursor, // createdAt
    int limit = 30,
  }) async {
    try {
      return await _postView
          .queryRows(
            queryFn: (q) => q.lt('created_at', cursor).order('created_at'),
            limit: limit,
          )
          .then((res) => Pageable.from(res));
    } on PostgrestException catch (e, st) {
      _logger?.e('feed datsource error', error: e, stackTrace: st);
      throwCustomExceptionFromPostgresException(e);
    }
  }

  @override
  Future<void> updatePost(UpdatePostRequestDto dto) async {
    try {
      await _postsTable.update(
        matchingRows: (q) => q.eq('id', dto.postId),
        data: {
          ...dto.toJson(),
          if (dto.visibilityText != null)
            'visibility': tryParseFeedVisibility(dto.visibilityText!),
        },
        returnRows: false,
      );
    } on PostgrestException catch (e, st) {
      _logger?.e('feed datsource error', error: e, stackTrace: st);
      throwCustomExceptionFromPostgresException(e);
    }
  }

  @override
  Future<void> deletePost(String postId, {bool isSoft = true}) async {
    try {
      isSoft
          ? _postsTable.update(
              matchingRows: (q) => q.eq('id', postId),
              data: {'deleted_at': DateTime.now().toUtc().toIso8601String()},
              returnRows: false,
            )
          : _postsTable.delete(
              matchingRows: (q) => q.eq('id', postId),
              returnRows: false,
            );
    } on PostgrestException catch (e, st) {
      _logger?.e('feed datsource error', error: e, stackTrace: st);
      throwCustomExceptionFromPostgresException(e);
    }
  }

  /// -──── likes ─────

  @override
  Future<FeedPostLikesRow?> findPostLike(String postId) async {
    try {
      return await _postLikesTable.querySingleRow(
        queryFn: (q) => q.eq('post_id', postId).eq('user_id', _currentUserId),
      );
    } on PostgrestException catch (e, st) {
      _logger?.e('feed datsource error', error: e, stackTrace: st);
      throwCustomExceptionFromPostgresException(e);
    }
  }

  /// -──── comments ─────
  @override
  Future<FeedCommentsRow> addComment(CreateCommentRequestDto dto) async {
    try {
      return await _commentTable.insert({
        if (dto.clientCommentId != null) 'id': dto.clientCommentId,
        ...dto.toJson(),
      });
    } on PostgrestException catch (e, st) {
      _logger?.e('feed datsource error', error: e, stackTrace: st);
      throwCustomExceptionFromPostgresException(e);
    }
  }

  @override
  Future<Pageable<VFeedCommentListRow>> fetchComments({
    required String postId,
    required String cursor, // created_at
    int limit = 30,
    bool ascending = true, // 타임라인 정렬 방향
  }) async {
    try {
      return await _commentView
          .queryRows(
            queryFn: (q) => q
                .eq('post_id', postId)
                .lt('created_at', cursor)
                .order('created_at', ascending: ascending),
            limit: limit,
          )
          .then((res) => Pageable.from(res));
    } on PostgrestException catch (e, st) {
      _logger?.e('feed datsource error', error: e, stackTrace: st);
      throwCustomExceptionFromPostgresException(e);
    }
  }

  @override
  Future<void> deleteComment(String commentId, {bool isSoft = true}) async {
    try {
      isSoft
          ? await _commentTable.update(
              matchingRows: (q) => q.eq('id', commentId),
              data: {'deleted_at': DateTime.now().toUtc().toIso8601String()},
              returnRows: false,
            )
          : await _commentTable.delete(
              matchingRows: (q) => q.eq('id', commentId),
              returnRows: false,
            );
    } on PostgrestException catch (e, st) {
      _logger?.e('feed datsource error', error: e, stackTrace: st);
      throwCustomExceptionFromPostgresException(e);
    }
  }

  /// -──── media ─────
  @override
  Future<FeedMediaRow> insertMedia(InsertMediaRequestDto dto) async {
    try {
      return await _mediaTable.insert({...dto.toJson()});
    } on PostgrestException catch (e, st) {
      _logger?.e('feed datsource error', error: e, stackTrace: st);
      throwCustomExceptionFromPostgresException(e);
    }
  }

  @override
  Future<List<FeedMediaRow>> getMedias(String postId) async {
    try {
      return await _mediaTable.queryRows(
        queryFn: (q) => q
            .eq('post_id', postId)
            .order('sort_order', ascending: true)
            .order('created_at', ascending: true),
      );
    } on PostgrestException catch (e, st) {
      _logger?.e('feed datsource error', error: e, stackTrace: st);
      throwCustomExceptionFromPostgresException(e);
    }
  }

  @override
  Future<void> deleteMedia(String mediaId) async {
    try {
      await _mediaTable.delete(
        matchingRows: (q) => q.eq('id', mediaId),
        returnRows: false,
      );
    } on PostgrestException catch (e, st) {
      _logger?.e('feed datsource error', error: e, stackTrace: st);
      throwCustomExceptionFromPostgresException(e);
    }
  }

  @override
  Future<void> reorderMedias(ReorderMediaRequestDto dto) async {
    try {
      if (dto.orders.isEmpty) {
        _logger?.w('orders param is empty');
        return;
      }
      await Future.wait(
        dto.orders.entries.map(
          (e) async => await _mediaTable.update(
            matchingRows: (q) => q.eq('id', e.key).eq('post_id', dto.postId),
          ),
        ),
      );
    } on PostgrestException catch (e, st) {
      _logger?.e('feed datsource error', error: e, stackTrace: st);
      throwCustomExceptionFromPostgresException(e);
    }
  }

  /// -──── Utils ─────
  FeedVisibility tryParseFeedVisibility(String text) {
    try {
      return FeedVisibility.values.where((e) => e.name == text).first;
    } catch (e, st) {
      _logger?.w('visibility is invalid', error: e, stackTrace: st);
      return FeedVisibility.public;
    }
  }
}
