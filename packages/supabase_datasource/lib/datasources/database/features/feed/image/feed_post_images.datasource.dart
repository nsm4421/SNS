part of 'feed_post_images.datasource_impl.dart';

abstract mixin class FeedPostImageDataSource {
  Future<void> insertImages(Iterable<InsertFeedPostImageRequestModel> request);
}
