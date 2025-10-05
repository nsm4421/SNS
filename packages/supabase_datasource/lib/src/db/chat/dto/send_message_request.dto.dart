import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';

part 'send_message_request.dto.freezed.dart';

part 'send_message_request.dto.g.dart';

@freezed
@JsonSerializable()
class SendMessageRequestDto with _$SendMessageRequestDto {
  SendMessageRequestDto({
    this.messageId,
    required this.roomId,
    required this.content,
    this.msgType = MessageType.text,
    this.metadata,
  });

  @JsonKey(name: 'id', includeToJson: false)
  final String? messageId;
  @JsonKey(name: 'room_id')
  final String roomId;
  final String content;
  @JsonKey(name: 'msg_type')
  final MessageType msgType;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => _$SendMessageRequestDtoToJson(this);
}
