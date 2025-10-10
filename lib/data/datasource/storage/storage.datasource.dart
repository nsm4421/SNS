import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:supabase/supabase.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';

import 'stprage_error_handler_mixin.dart';

part 'storage.datasource_impl.dart';

abstract interface class StorageDataSource {
  Future<bool> getIsBucketExists(String bucketName, {bool public = true});

  /// 바이트 업로드
  Future<Uri> uploadBytesThenReturnPublicUrl({
    required String bucketName,
    required String objectPath,
    required Uint8List bytes,
    required String mimeType,
    bool upsert = false,
  });

  Future<Uri> uploadBytesWithOnProgressThenReturnPublicUrl({
    required String bucketName,
    required String objectPath,
    required Uint8List bytes,
    required String mimeType,
    bool upsert = false,
    required void Function(double progress) onProgress, // progress : 0~1
  });

  /// 파일 삭제
  Future<void> delete({required String bucketName, required String path});

  /// 여러 파일 삭제
  Future<void> deleteAll({
    required String bucketName,
    required List<String> paths,
  });

  /// 공개 URL
  Uri getPublicUrl({
    required String bucketName,
    required String path,
    TransformOptions? transform,
  });

  /// 사인드 URL 발급
  Future<Uri> createSignedUrlForDownload({
    required String bucketName,
    required String path,
    Duration expiresIn = const Duration(minutes: 30),
  });

  /// 리스트(폴더 단위)
  Future<List<String>> list({
    required String bucketName,
    required String prefix, // 예: 'posts/<postId>/'
    int limit = 30,
    bool recursive = false,
  });

  /// 이동/복사(필요시)
  Future<void> move({
    required String bucketName,
    required String fromPath,
    required String toPath,
  });

  Future<void> copy({
    required String bucketName,
    required String fromPath,
    required String toPath,
  });
}
