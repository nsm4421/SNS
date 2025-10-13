part of 'feed_rpc.datasource.dart';

class FeedRpcDataSourceImpl implements FeedRpcDataSource {
  final SupabaseClient _client;

  FeedRpcDataSourceImpl({required SupabaseClient client}) : _client = client;

  @override
  Future<(bool likedByMe, int likeCount)> toggleLike(String postId) async {
    late bool likedByMe;
    late int likeCount;
    await _client
        .rpc('toggle_feed_like', params: {'_post_id': postId})
        .then((res) => res as Iterable)
        .then((res) => res.first as Map)
        .then((res) {
          likedByMe = res['liked'];
          likeCount = res['like_count'];
        });
    return (likedByMe, likeCount);
  }
}
