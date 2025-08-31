import 'dart:io';

import 'package:supabase_datasource/datasources/storage/storage.datasource_impl.dart';

part 'feed_storage.dastasource.dart';

class FeedStorageDataSourceImpl implements FeedStorageDataSource {
  final SupabaseStorageDataSource _supabaseStorageDataSource;

  FeedStorageDataSourceImpl(this._supabaseStorageDataSource);

  static const String _bucketId = 'feed_images';

  @override
  Future<Iterable<String>> uploadFeedImages({
    required String feedId,
    required List<File> images,
  }) async {
    return await Future.wait(
      images.indexed.map(
        (e) async =>
            await _supabaseStorageDataSource.uploadImageAndReturnPublicUrl(
              bucketId: _bucketId,
              objectPath: '$feedId/${e.$1}',
              file: e.$2,
            ),
      ),
    );
  }
}
