import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_comment_request.model.freezed.dart';

part 'create_post_comment_request.model.g.dart';

@freezed
@JsonSerializable()
class CreatePostCommentRequestModel with _$CreatePostCommentRequestModel {
  @JsonKey(name: 'post_id')
  final String postId;
  @JsonKey(name: 'parent_id')
  final String? parentId;
  final String content;

  CreatePostCommentRequestModel({
    required this.postId,
    this.parentId,
    required this.content,
  });

  factory CreatePostCommentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePostCommentRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostCommentRequestModelToJson(this);
}

class CreatePostParentCommentRequestModel
    extends CreatePostCommentRequestModel {
  CreatePostParentCommentRequestModel({
    required super.postId,
    required super.content,
  });
}

class CreatePostChildCommentRequestModel extends CreatePostCommentRequestModel {
  CreatePostChildCommentRequestModel({
    required super.postId,
    required super.content,
    required super.parentId, // 부모 댓글 id
  });
}
