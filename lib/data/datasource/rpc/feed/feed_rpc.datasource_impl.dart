part of 'feed_rpc.datasource.dart';

class FeedRpcDataSourceImpl implements FeedRpcDataSource {
  final SupabaseClient _client;

  FeedRpcDataSourceImpl({required SupabaseClient client}) : _client = client;

  @override
  Future<(bool likedByMe, int likeCount)> toggleLike(String postId) async {
    final res =
        await _client.rpc('toggle_feed_like', params: {'_post_id': postId})
            as Map;
    return (res['liked'] as bool, res['like_count'] as int);
  }
}
