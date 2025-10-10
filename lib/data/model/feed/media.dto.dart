import 'package:freezed_annotation/freezed_annotation.dart';

part 'media.dto.freezed.dart';

part 'media.dto.g.dart';

@freezed
@JsonSerializable()
class InsertMediaRequestDto with _$InsertMediaRequestDto {
  @JsonKey(name: 'post_id')
  final String postId;
  @JsonKey(name: 'storage_path')
  final String storagePath;
  @JsonKey(name: 'mime_type')
  final String? mimeType;
  final int? width;
  final int? height;
  @JsonKey(name: 'sort_order')
  final int sortOrder;

  InsertMediaRequestDto({
    required this.postId,
    required this.storagePath,
    this.mimeType,
    this.width,
    this.height,
    required this.sortOrder,
  });

  Map<String, dynamic> toJson() => _$InsertMediaRequestDtoToJson(this);
}

class ReorderMediaRequestDto {
  final String postId;

  /// mediaId -> sortOrder
  final Map<String, int> orders;

  ReorderMediaRequestDto({required this.postId, required this.orders});
}
