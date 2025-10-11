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
    required String storagePath,
    required Uint8List bytes,
    String? mimeType,
    bool upsert = false,
  }) async {
    try {
      return await _storage
          .from(bucketName)
          .uploadBinary(
            storagePath,
            bytes,
            fileOptions: FileOptions(contentType: mimeType, upsert: upsert),
          )
          .then((p) => getPublicUrl(storagePath: p, bucketName: bucketName));
    } catch (e, st) {
      _logger?.e('storage exception', error: e, stackTrace: st);
      throwCustomExceptionFromException(e);
    }
  }

  @override
  Future<Uri> uploadBytesWithOnProgressThenReturnPublicUrl({
    required String bucketName,
    required String storagePath,
    required Uint8List bytes,
    String? mimeType,
    bool upsert = false,
    required void Function(double progress) onProgress,
  }) async {
    try {
      final signedUrlForUpload = await _storage
          .from(bucketName)
          .createSignedUploadUrl(storagePath)
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
      return getPublicUrl(bucketName: bucketName, storagePath: storagePath);
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
    required List<String> storagePaths,
  }) async {
    try {
      if (storagePaths.isEmpty) {
        _logger?.w('paths are not given');
      }
      await _storage.from(bucketName).remove(storagePaths);
    } catch (e, st) {
      _logger?.e('storage exception', error: e, stackTrace: st);
      throwCustomExceptionFromException(e);
    }
  }

  @override
  Uri getPublicUrl({
    required String bucketName,
    required String storagePath,
    TransformOptions? transform,
  }) {
    try {
      return Uri.parse(
        _storage
            .from(bucketName)
            .getPublicUrl(storagePath, transform: transform),
      );
    } catch (e, st) {
      _logger?.e('storage exception', error: e, stackTrace: st);
      throwCustomExceptionFromException(e);
    }
  }

  @override
  Future<Uri> createSignedUrlForDownload({
    required String bucketName,
    required String storagePath,
    Duration expiresIn = const Duration(minutes: 30),
  }) async {
    try {
      return await _storage
          .from(bucketName)
          .createSignedUrl(storagePath, expiresIn.inSeconds)
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
