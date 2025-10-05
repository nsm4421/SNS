import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_chat_room_request.dto.freezed.dart';

part 'create_chat_room_request.dto.g.dart';

@freezed
@JsonSerializable()
class CreateChatRoomRequestDto with _$CreateChatRoomRequestDto {
  CreateChatRoomRequestDto({
    this.roomId,
    this.isGroup = false,
    this.name,
    required this.memberIds,
  });

  @JsonKey(includeToJson: true)
  final String? roomId;
  @JsonKey(name: 'is_group')
  final bool isGroup;
  final String? name;
  @JsonKey(name: 'member_ids')
  final Iterable<String> memberIds;

  Map<String, dynamic> toJson() => _$CreateChatRoomRequestDtoToJson(this);
}
