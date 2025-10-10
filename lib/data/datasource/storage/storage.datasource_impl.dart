part of 'storage.datasource.dart';

class SupabaseStorageDataSourceImpl
    with StorageHandlerMixin
    implements StorageDataSource {
  late final SupabaseStorageClient _storage;
  late final Dio _dio;
  late final Logger? _logger;

  SupabaseStorageDataSourceImpl({
    required SupabaseClient client,
    required Dio dio,
    Logger? logger,
  }) {
    _storage = client.storage;
    _dio = dio;
    _logger = logger;
  }

  @override
  Future<bool> getIsBucketExists(
    String bucketName, {
    bool public = true,
  }) async {
    try {
      return await _storage.listBuckets().then(
        (res) => res.any((b) => (b.name == bucketName) && (b.public == public)),
      );
    } catch (e, st) {
      _logger?.e('storage exception', error: e, stackTrace: st);
      return false;
    }
  }

  @override
  Future<Uri> uploadBytesThenReturnPublicUrl({
    required String bucketName,
    required String objectPath,
    required Uint8List bytes,
    required String mimeType,
    bool upsert = false,
  }) async {
    try {
      return await _storage
          .from(bucketName)
          .uploadBinary(
            objectPath,
            bytes,
            fileOptions: FileOptions(contentType: mimeType, upsert: upsert),
          )
          .then((p) => getPublicUrl(path: p, bucketName: bucketName));
    } catch (e, st) {
      _logger?.e('storage exception', error: e, stackTrace: st);
      throwCustomExceptionFromException(e);
    }
  }

  @override
  Future<Uri> uploadBytesWithOnProgressThenReturnPublicUrl({
    required String bucketName,
    required String objectPath,
    required Uint8List bytes,
    required String mimeType,
    bool upsert = false,
    required void Function(double progress) onProgress,
  }) async {
    try {
      final signedUrlForUpload = await _storage
          .from(bucketName)
          .createSignedUploadUrl(objectPath)
          .then((res) => res.signedUrl);
      await _dio.put(
        signedUrlForUpload,
        data: bytes,
        options: Options(
          headers: {'Content-Type': mimeType, if (upsert) 'x-upsert': 'true'},
        ),
        onSendProgress: (count, total) {
          if (total > 0) {
            onProgress(count / total);
          }
        },
      );
      return getPublicUrl(bucketName: bucketName, path: objectPath);
    } catch (e, st) {
      _logger?.e('storage exception', error: e, stackTrace: st);
      throwCustomExceptionFromException(e);
    }
  }

  @override
  Future<void> delete({
    required String bucketName,
    required String path,
  }) async {
    try {
      await _storage.from(bucketName).remove([path]);
    } catch (e, st) {
      _logger?.e('storage exception', error: e, stackTrace: st);
      throwCustomExceptionFromException(e);
    }
  }

  @override
  Future<void> deleteAll({
    required String bucketName,
    required List<String> paths,
  }) async {
    try {
      if (paths.isEmpty) {
        _logger?.w('paths are not given');
      }
      await _storage.from(bucketName).remove(paths);
    } catch (e, st) {
      _logger?.e('storage exception', error: e, stackTrace: st);
      throwCustomExceptionFromException(e);
    }
  }

  @override
  Uri getPublicUrl({
    required String bucketName,
    required String path,
    TransformOptions? transform,
  }) {
    try {
      return Uri.parse(
        _storage.from(bucketName).getPublicUrl(path, transform: transform),
      );
    } catch (e, st) {
      _logger?.e('storage exception', error: e, stackTrace: st);
      throwCustomExceptionFromException(e);
    }
  }

  @override
  Future<Uri> createSignedUrlForDownload({
    required String bucketName,
    required String path,
    Duration expiresIn = const Duration(minutes: 30),
  }) async {
    try {
      return await _storage
          .from(bucketName)
          .createSignedUrl(path, expiresIn.inSeconds)
          .then(Uri.parse);
    } catch (e, st) {
      _logger?.e('storage exception', error: e, stackTrace: st);
      throwCustomExceptionFromException(e);
    }
  }

  @override
  Future<List<String>> list({
    required String bucketName,
    required String prefix,
    int? limit,
    bool recursive = false,
  }) async {
    try {
      return _storage
          .from(bucketName)
          .list(
            path: prefix,
            searchOptions: SearchOptions(limit: limit),
          )
          .then((res) => res.map((e) => posix.join(prefix, e.name)).toList());
    } catch (e, st) {
      _logger?.e('storage exception', error: e, stackTrace: st);
      throwCustomExceptionFromException(e);
    }
  }

  @override
  Future<void> move({
    required String bucketName,
    required String fromPath,
    required String toPath,
  }) async {
    try {
      await _storage.from(bucketName).move(fromPath, toPath);
    } catch (e, st) {
      _logger?.e('storage exception', error: e, stackTrace: st);
      throwCustomExceptionFromException(e);
    }
  }

  @override
  Future<void> copy({
    required String bucketName,
    required String fromPath,
    required String toPath,
  }) async {
    try {
      await _storage.from(bucketName).copy(fromPath, toPath);
    } catch (e, st) {
      _logger?.e('storage exception', error: e, stackTrace: st);
      throwCustomExceptionFromException(e);
    }
  }
}
