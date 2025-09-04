import 'package:shared/response_wrapper/api_response/api_exception.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'feed_post_likes.datasource.dart';

class FeedPostLikeDataSourceImpl implements FeedPostLikeDataSource {
  FeedPostLikeDataSourceImpl({
    required SupabaseClient client,
    required FeedPostLikesTable feedPostLikesTable,
    required FeedWithImagesAndCountsTable feedWithImagesWithCountsTable,
  }) : _client = client,
       _feedPostLikesTable = feedPostLikesTable,
       _feedWithImagesWithCountsTable = feedWithImagesWithCountsTable;

  final SupabaseClient _client;
  final FeedPostLikesTable _feedPostLikesTable;
  final FeedWithImagesAndCountsTable _feedWithImagesWithCountsTable;

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

  @Deprecated('use likes count field on feed_posts table instead')
  @override
  Future<int> getLikeCount(String postId) async {
    return _feedWithImagesWithCountsTable
        .querySingleRow(queryFn: (q) => q.eq('post_id', postId))
        .then((res) => res?.likesCount)
        .then((cnt) => cnt ?? 0);
  }

  @override
  Future<int?> toggleLike(String postId) async {
    return await _client.rpc<int?>(
      'toggle_post_like',
      params: {'p_post_id': postId},
    );
  }
}
