import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.model.freezed.dart';

part 'message.model.g.dart';

@freezed
@JsonSerializable()
class MessageModel with _$MessageModel {
  MessageModel({
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.edited = false,
    this.deleted = false,
    this.createdAt,
    this.updatedAt,
  });

  @JsonKey(name: 'conversation_id')
  final String conversationId;
  @JsonKey(name: 'sender_id')
  final String senderId;
  final MessageContentModel content;
  final bool edited;
  final bool deleted;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}

@Freezed(unionKey: 'type', unionValueCase: FreezedUnionCase.snake)
sealed class MessageContentModel with _$MessageContentModel {
  const factory MessageContentModel.text({
    required String text,
  }) = MessageText;

  const factory MessageContentModel.image({
    required String url,
    int? width,
    int? height,
  }) = MessageImage;

  const factory MessageContentModel.file({
    required String url,
    required String name,
    int? size,
  }) = MessageFile;

  factory MessageContentModel.fromJson(Map<String, dynamic> json) =>
      _$MessageContentModelFromJson(json);
}
