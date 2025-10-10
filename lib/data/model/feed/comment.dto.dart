import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.dto.freezed.dart';

part 'comment.dto.g.dart';

@freezed
@JsonSerializable()
class CreateCommentRequestDto with _$CreateCommentRequestDto {
  CreateCommentRequestDto({
    required this.postId,
    this.clientCommentId,
    this.content = '',
    this.parentId,
  });

  @JsonKey(name: 'post_id')
  final String postId;
  @JsonKey(name: 'id', includeToJson: false)
  final String? clientCommentId;
  final String content;
  @JsonKey(name: 'parent_id')
  final String? parentId;

  Map<String, dynamic> toJson() => _$CreateCommentRequestDtoToJson(this);
}
