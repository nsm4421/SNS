import 'dart:typed_data';
import 'package:karma/core/extension/string.extension.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';
import '../storage.datasource.dart';

part 'feed_bucket.datasource_impl.dart';

abstract interface class FeedBucketDataSource {
  // <feedId>/<uuid>.ext
  String buildObjectPath({required String feedId, required String filename});

  Future<Uri> uploadBytes({
    required String feedId,
    required String filename,
    required String mimeType,
    required Uint8List bytes,
    void Function(double progress)? onProgress,
    bool upsert = false,
  });

  Future<void> delete(String objectPath);

  Uri getPublicUrl(
    String objectPath, {
    int? width,
    int? height,
    int quality = 80,
  });
}
