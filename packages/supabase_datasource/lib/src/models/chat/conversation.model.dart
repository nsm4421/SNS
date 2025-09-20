import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.model.freezed.dart';

part 'conversation.model.g.dart';

enum ConversationKind { dm, group }

@freezed
@JsonSerializable()
class ConversationModel with _$ConversationModel {
  ConversationModel({
    required this.id,
    this.kind = ConversationKind.dm,
    required this.memberIds,
    this.title,
    this.lastMessageId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final ConversationKind kind;
  @JsonKey(name: 'member_ids')
  final List<String> memberIds;
  final String? title;
  @JsonKey(name: 'last_messsage_id')
  final String? lastMessageId;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);
}
