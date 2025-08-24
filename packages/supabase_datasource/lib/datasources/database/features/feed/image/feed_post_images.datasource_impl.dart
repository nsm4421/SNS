import 'package:supabase_datasource/datasources/database/generated/database.dart';
import 'package:supabase_datasource/datasources/model/feed/image/insert_feed_post_image_request.model.dart';

part 'feed_post_images.datasource.dart';

class FeedPostImageDataSourceImpl implements FeedPostImageDataSource {
  FeedPostImageDataSourceImpl(this._feedPostImagesTable);

  final FeedPostImagesTable _feedPostImagesTable;

  @override
  Future<void> insertImages(
    List<InsertFeedPostImageRequestModel> request,
  ) async {
    await Future.wait(
      request.indexed.map(
        (e) async => _feedPostImagesTable.insert(
          e.$2.copyWith(orderIndex: e.$1).toJson(),
        ),
      ),
    );
  }
}
