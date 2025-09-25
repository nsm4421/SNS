import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_datasource/src/models/supabase/database.dart';

part 'chat_room.model.freezed.dart';

part 'chat_room.model.g.dart';

@freezed
@JsonSerializable()
class ChatRoomModel with _$ChatRoomModel {
  ChatRoomModel({
    required this.id,
    this.isGroup = false,
    this.name,
    this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  @JsonKey(name: 'is_group')
  final bool isGroup;
  final String? name;
  @JsonKey(name: 'last_message_at')
  final DateTime? lastMessageAt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomModelToJson(this);

  static ChatRoomModel fromRow(ChatRoomsRow row) {
    return ChatRoomModel(
      id: row.id,
      isGroup: row.isGroup,
      name: row.name,
      lastMessageAt: row.lastMessageAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
