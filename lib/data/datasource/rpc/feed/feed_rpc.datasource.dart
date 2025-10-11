import 'package:supabase/supabase.dart';

part 'feed_rpc.datasource_impl.dart';

abstract interface class FeedRpcDataSource {
  Future<(bool likedByMe, int likeCount)> toggleLike(String postId);
}
