import 'dart:io';

import 'package:supabase_datasource/datasources/storage/storage.datasource_impl.dart';

part 'feed_storage.dastasource.dart';

class FeedStorageDataSourceImpl implements FeedStorageDataSource {
  final SupabaseStorageDataSource _supabaseStorageDataSource;

  FeedStorageDataSourceImpl(this._supabaseStorageDataSource);

  static const String _bucketId = 'FEED_IMAGE';

  @override
  Future<Iterable<String>> uploadFeedImages({
    required String currentUid,
    required String postId,
    required List<File> images,
  }) async {
    return await Future.wait(
      images.indexed.map(
        (e) async =>
            await _supabaseStorageDataSource.uploadImageAndReturnPublicUrl(
              bucketId: _bucketId,
              objectPath: '$currentUid/$postId/${e.$1}.jpg',
              file: e.$2,
            ),
      ),
    );
  }
}
