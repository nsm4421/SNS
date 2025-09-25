import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_member_request.dto.freezed.dart';

part 'add_member_request.dto.g.dart';

@freezed
@JsonSerializable()
class AddMemberRequestDto with _$AddMemberRequestDto {
  AddMemberRequestDto({
    required this.roomId,
    required this.userId,
    this.role = 'member',
  });

  @JsonKey(name: 'room_id')
  final String roomId;
  @JsonKey(name: 'user_id')
  final String? userId;
  final String role; // 'member' | 'owner' | 'admin'

  factory AddMemberRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AddMemberRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddMemberRequestDtoToJson(this);
}
