import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_post_image.model.freezed.dart';

part 'feed_post_image.model.g.dart';

@freezed
@JsonSerializable()
class FeedPostImageModel with _$FeedPostImageModel {
  final String id;
  @JsonKey(name: 'post_id')
  final String postId;
  @JsonKey(name: 'bucket_id')
  final String bucktId;
  @JsonKey(name: 'object_path')
  final String objectPath;
  @JsonKey(name: 'order_index')
  @Default(0)
  final int orderIndex;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  FeedPostImageModel({
    required this.id,
    required this.postId,
    required this.bucktId,
    required this.objectPath,
    required this.orderIndex,
    required this.createdAt,
  });

  factory FeedPostImageModel.fromJson(Map<String, dynamic> json) =>
      _$FeedPostImageModelFromJson(json);
}
