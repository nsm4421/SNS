part of 'feed_bucket.datasource.dart';

class SupabaseFeedBucketDataSourceImpl implements FeedBucketDataSource {
  final StorageDataSource _storageDataSource;

  SupabaseFeedBucketDataSourceImpl({
    required StorageDataSource storageDataSource,
  }) : _storageDataSource = storageDataSource;

  static const String _bucketName = "feeds";

  @override
  String buildObjectPath({required String feedId, required String filename}) {
    final segments = [feedId, const Uuid().v4(), filename.ext];
    return posix.joinAll(segments);
  }

  @override
  Uri getPublicUrl(
    String objectPath, {
    int? width,
    int? height,
    int quality = 80,
  }) {
    return _storageDataSource.getPublicUrl(
      bucketName: _bucketName,
      path: objectPath,
      transform: TransformOptions(
        width: width,
        height: height,
        quality: quality,
        resize: ResizeMode.cover,
      ),
    );
  }

  @override
  Future<Uri> uploadBytes({
    required String feedId,
    required String filename,
    required String mimeType,
    required Uint8List bytes,
    void Function(double progress)? onProgress,
    bool upsert = false,
  }) async {
    return onProgress == null
        ? await _storageDataSource.uploadBytesThenReturnPublicUrl(
            bucketName: _bucketName,
            objectPath: buildObjectPath(feedId: feedId, filename: filename),
            bytes: bytes,
            mimeType: mimeType,
          )
        : await _storageDataSource.uploadBytesWithOnProgressThenReturnPublicUrl(
            bucketName: _bucketName,
            objectPath: buildObjectPath(feedId: feedId, filename: filename),
            bytes: bytes,
            mimeType: mimeType,
            onProgress: onProgress,
          );
  }

  @override
  Future<void> delete(String objectPath) async {
    return _storageDataSource.delete(bucketName: _bucketName, path: objectPath);
  }
}
