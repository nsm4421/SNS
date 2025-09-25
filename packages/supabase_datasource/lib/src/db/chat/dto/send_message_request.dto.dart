import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_message_request.dto.freezed.dart';

part 'send_message_request.dto.g.dart';

@freezed
@JsonSerializable()
class SendMessageRequestDto with _$SendMessageRequestDto {
  SendMessageRequestDto({
    required this.roomId,
    required this.content,
    this.msgType = 'text',
    this.metadata
  });

  @JsonKey(name: 'room_id')
  final String roomId;
  final String content;
  @JsonKey(name: 'msg_type')
  final String msgType; // 'text' | 'image' | 'file'
  final Map<String, dynamic>? metadata;

  factory SendMessageRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageRequestDtoToJson(this);
}
