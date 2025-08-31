import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/api_response/api_exception.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';
import 'package:supabase_datasource/datasources/model/feed/post/create_feed_post_request.model.dart';

part 'feed_posts.datasource.dart';

class FeedPostDataSourceImpl implements FeedPostDataSource {
  const FeedPostDataSourceImpl({
    required FeedPostsTable feedPostsTable,
    required FeedWithImagesAndCountsTable feedWithImagesWithCountsTable,
  }) : _feedPostsTable = feedPostsTable,
       _feedWithImagesWithCountsTable = feedWithImagesWithCountsTable;

  final FeedPostsTable _feedPostsTable;
  final FeedWithImagesAndCountsTable _feedWithImagesWithCountsTable;

  @override
  Future<FeedPostsRow> createPost(CreateFeedPostRequestModel request) async {
    return _feedPostsTable.insert(request.toJson());
  }

  @override
  Future<void> deletePostById(String postId) async {
    await _feedPostsTable.delete(matchingRows: (q) => q.eq('id', postId));
  }

  @override
  Future<FeedWithImagesAndCountsRow> getPostWithCountById(String postId) async {
    final res = await _feedWithImagesWithCountsTable.querySingleRow(
      queryFn: (q) => q.eq('id', postId),
    );
    if (res == null) {
      throw ApiException.notFound('feed post with id [$postId] is not founded');
    }
    return res;
  }

  @override
  Future<Page<FeedWithImagesAndCountsRow>> fetchPosts({
    String? cursor,
    int limit = 20,
  }) async {
    return await _feedWithImagesWithCountsTable
        .queryRows(
          queryFn: (q) => q
              .lt('created_at', cursor ?? DateTime.now().toUtc())
              .order('created_at'),
          limit: limit,
        )
        .then(
          (res) => Page<FeedWithImagesAndCountsRow>(
            items: res,
            nextCursor: res.length < limit
                ? null
                : res.first.createdAt?.toUtc().toString(),
          ),
        );
  }
}
