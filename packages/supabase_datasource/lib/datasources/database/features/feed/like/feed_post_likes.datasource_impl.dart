import 'package:shared/response_wrapper/api_response/api_exception.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'feed_post_likes.datasource.dart';

class FeedPostLikeDataSourceImpl implements FeedPostLikeDataSource {
  FeedPostLikeDataSourceImpl({
    required SupabaseClient client,
    required FeedPostLikesTable feedPostLikesTable,
    required FeedPostsWithCountsTable feedPostsWithCountsTable,
  }) : _client = client,
       _feedPostLikesTable = feedPostLikesTable,
       _feedPostsWithCountsTable = feedPostsWithCountsTable;

  final SupabaseClient _client;
  final FeedPostLikesTable _feedPostLikesTable;
  final FeedPostsWithCountsTable _feedPostsWithCountsTable;

  @override
  Future<bool> getIsLike(String postId) async {
    final currentUid = _client.auth.currentUser?.id;
    if (currentUid == null) {
      throw ApiException.auth('session not found');
    }
    return _feedPostLikesTable
        .querySingleRow(
          queryFn: (q) => q.eq('post_id', postId).eq('user_id', currentUid),
        )
        .then((res) => res == null);
  }

  @override
  Future<int> getLikeCount(String postId) async {
    return _feedPostsWithCountsTable
        .querySingleRow(queryFn: (q) => q.eq('post_id', postId))
        .then((res) => res?.likesCount)
        .then((cnt) => cnt ?? 0);
  }

  @override
  Future<void> toggleLike(String postId) async {
    await _client.rpc<Map<String, dynamic>?>(
      'toggle_post_like',
      params: {'post_id': postId},
    );
  }
}
