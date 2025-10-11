import 'package:copy_with_extension/copy_with_extension.dart';

part 'feed_media.entity.g.dart';

@CopyWith(copyWithNull: true)
class FeedMediaEntity {
  final String postId;
  final String storagePath;
  final String? publicUrl;
  final String? id;
  final String? mimeType;
  final int? width;
  final int? height;
  final int? sortOrder;
  final DateTime? createdAt;

  FeedMediaEntity({
    required this.postId,
    required this.storagePath,
    this.publicUrl,
    this.id,
    this.mimeType,
    this.width,
    this.height,
    this.sortOrder,
    this.createdAt,
  });
}
