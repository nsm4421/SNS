import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

part 'storage.datasource.dart';

class SupabaseStorageDataSourceImpl implements SupabaseStorageDataSource {
  SupabaseStorageDataSourceImpl(this._storage);

  final SupabaseStorageClient _storage;

  @override
  Future<String> uploadImageAndReturnPublicUrl({
    required String bucketId,
    required String objectPath,
    required File file,
    String mimeType = 'image/jpeg',
    String cacheControl = '3600',
    bool upsert = true,
  }) async {
    await _storage
        .from(bucketId)
        .upload(
          objectPath,
          File(file.path),
          fileOptions: FileOptions(
            cacheControl: cacheControl,
            upsert: upsert,
            contentType: mimeType,
          ),
        );
    return _storage.from(bucketId).getPublicUrl(objectPath);
  }
}
