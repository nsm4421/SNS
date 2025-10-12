part of 'feed_bucket.datasource.dart';

class SupabaseFeedBucketDataSourceImpl implements FeedBucketDataSource {
  final StorageDataSource _storageDataSource;

  SupabaseFeedBucketDataSourceImpl({
    required StorageDataSource storageDataSource,
  }) : _storageDataSource = storageDataSource;

  static const String _bucketName = "feeds";

  @override
  String buildStoragePath({required String postId, required String filename}) {
    final segments = [postId, '${const Uuid().v4()}${filename.ext}'];
    return posix.joinAll(segments);
  }

  @override
  String getPublicUrl(String storagePath) {
    return _storageDataSource.getPublicUrl(
      bucketName: _bucketName,
      storagePath: storagePath,
    );
  }

  @override
  Future<String> uploadBytes({
    required String postId,
    required String filename,
    String? mimeType,
    required Uint8List bytes,
    void Function(double progress)? onProgress,
    bool upsert = false,
  }) async {
    return onProgress == null
        ? await _storageDataSource.uploadBytesThenReturnStoragePath(
            bucketName: _bucketName,
            storagePath: buildStoragePath(postId: postId, filename: filename),
            bytes: bytes,
            mimeType: mimeType,
          )
        : await _storageDataSource
              .uploadBytesWithOnProgressThenReturnStoragePath(
                bucketName: _bucketName,
                storagePath: buildStoragePath(
                  postId: postId,
                  filename: filename,
                ),
                bytes: bytes,
                mimeType: mimeType,
                onProgress: onProgress,
              );
  }

  @override
  Future<void> delete(String storagePath) async {
    return _storageDataSource.delete(
      bucketName: _bucketName,
      path: storagePath,
    );
  }

  @override
  Future<String> createSignedUrlForDownload({
    required String storagePath,
    Duration expiresIn = const Duration(minutes: 30),
  }) async {
    return await _storageDataSource.createSignedUrlForDownload(
      bucketName: _bucketName,
      storagePath: storagePath,
      expiresIn: expiresIn,
    );
  }
}
