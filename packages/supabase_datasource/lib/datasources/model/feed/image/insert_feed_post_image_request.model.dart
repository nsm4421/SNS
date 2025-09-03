import 'package:freezed_annotation/freezed_annotation.dart';

part 'insert_feed_post_image_request.model.freezed.dart';

part 'insert_feed_post_image_request.model.g.dart';

@freezed
@JsonSerializable()
class InsertFeedPostImageRequestModel with _$InsertFeedPostImageRequestModel {
  @JsonKey(name: 'object_path')
  final String objectPath;
  final int? width;
  final int? height;
  @JsonKey(name: 'order_index')
  @Default(0)
  final int orderIndex;
  @JsonKey(name: 'post_id')
  final String postId;

  InsertFeedPostImageRequestModel({
    required this.objectPath,
    this.width,
    this.height,
    this.orderIndex = 0,
    required this.postId,
  });

  factory InsertFeedPostImageRequestModel.fromJson(
    Map<String, dynamic> json,
  ) => _$InsertFeedPostImageRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$InsertFeedPostImageRequestModelToJson(this);
}
