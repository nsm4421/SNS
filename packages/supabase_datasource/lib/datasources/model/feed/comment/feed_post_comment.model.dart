import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_post_comment.model.freezed.dart';

part 'feed_post_comment.model.g.dart';

@freezed
@JsonSerializable()
class FeedPostCommentModel with _$FeedPostCommentModel {
  final String id;
  @JsonKey(name: 'post_id')
  final String postId;
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'parent_id')
  final String? parentId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  FeedPostCommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    this.parentId,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory FeedPostCommentModel.fromJson(Map<String, dynamic> json) =>
      _$FeedPostCommentModelFromJson(json);
}
