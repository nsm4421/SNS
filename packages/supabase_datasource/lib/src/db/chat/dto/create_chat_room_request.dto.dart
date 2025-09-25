import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_chat_room_request.dto.freezed.dart';

part 'create_chat_room_request.dto.g.dart';

@freezed
@JsonSerializable()
class CreateChatRoomRequestDto with _$CreateChatRoomRequestDto {
  CreateChatRoomRequestDto({
    this.isGroup = false,
    this.name,
    required this.memberIds,
  });

  @JsonKey(name: 'is_group')
  final bool isGroup;
  final String? name;
  @JsonKey(name: 'member_ids')
  final Iterable<String> memberIds;

  factory CreateChatRoomRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateChatRoomRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChatRoomRequestDtoToJson(this);
}
