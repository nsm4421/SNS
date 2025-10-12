import 'dart:typed_data';
import 'package:karma/core/extension/string.extension.dart';
import 'package:karma/core/util/app_logger.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';
import '../storage.datasource.dart';

part 'feed_bucket.datasource_impl.dart';

abstract interface class FeedBucketDataSource {
  // <feedId>/<uuid>.ext
  String buildStoragePath({required String postId, required String filename});

  Future<String> uploadBytes({
    required String postId,
    required String filename,
    String? mimeType,
    required Uint8List bytes,
    void Function(double progress)? onProgress,
    bool upsert = false,
  });

  Future<void> delete(String storagePath);

  String getPublicUrl(String storagePath);

  Future<String> createSignedUrlForDownload({
    required String storagePath,
    Duration expiresIn = const Duration(minutes: 30),
  });
}
