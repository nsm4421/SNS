import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_message_request.dto.freezed.dart';

part 'edit_message_request.dto.g.dart';

@freezed
@JsonSerializable()
class EditMessageRequestDto with _$EditMessageRequestDto {
  EditMessageRequestDto({
    required this.messageId,
    required this.content,
    this.metadata,
  });

  @JsonKey(name: 'message_id')
  final String messageId;
  final String content;
  @JsonKey(name: 'meta_data')
  final Map<String, dynamic>? metadata;

  factory EditMessageRequestDto.fromJson(Map<String, dynamic> json) =>
      _$EditMessageRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EditMessageRequestDtoToJson(this);
}
