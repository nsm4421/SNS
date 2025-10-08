import 'package:freezed_annotation/freezed_annotation.dart';

part 'typing_event.dto.g.dart';

part 'typing_event.dto.freezed.dart';

@freezed
@JsonSerializable()
class TypingEventDto with _$TypingEventDto {
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'is_typing')
  final bool isTyping;
  final DateTime at;

  const TypingEventDto({
    required this.userId,
    this.isTyping = false,
    required this.at,
  });

  factory TypingEventDto.fromJson(Map<String, dynamic> json) =>
      _$TypingEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TypingEventDtoToJson(this);
}
