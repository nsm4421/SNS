part of 'storage.datasource_impl.dart';

abstract class SupabaseStorageDataSource {
  Future<String> uploadImageAndReturnPublicUrl({
    required String bucketId,
    required String objectPath,
    required File file,
    bool upsert = true
  });
}
