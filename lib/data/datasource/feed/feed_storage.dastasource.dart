part of 'feed_storage.dastasource_impl.dart';

abstract class FeedStorageDataSource {
  Future<Iterable<String>> uploadFeedImages({
    required String currentUid,
    required String feedId,
    required List<File> images,
  });
}
