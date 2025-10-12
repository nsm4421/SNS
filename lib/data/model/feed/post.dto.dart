import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.dto.freezed.dart';

part 'post.dto.g.dart';

@freezed
@JsonSerializable()
class CreatePostRequestDto with _$CreatePostRequestDto {
  CreatePostRequestDto({
    this.clientPostId,
    this.content = '',
    this.visibilityText = 'public',
    this.replyToId,
  });

  @JsonKey(name: 'id', includeToJson: false)
  final String? clientPostId;
  final String content;
  @JsonKey(includeToJson: false)
  final String visibilityText;
  @JsonKey(name: 'reply_to_id')
  final String? replyToId;

  Map<String, dynamic> toJson() => _$CreatePostRequestDtoToJson(this);
}

@freezed
@JsonSerializable()
class UpdatePostRequestDto with _$UpdatePostRequestDto {
  UpdatePostRequestDto({
    required this.postId,
    this.content,
    this.visibilityText,
  });

  @JsonKey(name: 'id', includeToJson: false)
  final String postId;
  final String? content;
  @JsonKey(includeToJson: false)
  final String? visibilityText;

  Map<String, dynamic> toJson() => _$UpdatePostRequestDtoToJson(this);
}
