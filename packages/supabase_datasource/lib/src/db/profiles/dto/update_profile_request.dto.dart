import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_profile_request.dto.freezed.dart';

part 'update_profile_request.dto.g.dart';

@freezed
@JsonSerializable()
class UpdateProfileRequestDto with _$UpdateProfileRequestDto {
  UpdateProfileRequestDto({
    required this.userId,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.statusMessage,
  });

  @JsonKey(name: 'user_id')
  final String userId;
  final String username;
  @JsonKey(name: 'display_name')
  final String? displayName;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final String? bio;
  @JsonKey(name: 'status_message')
  final String? statusMessage;

  Map<String, dynamic> toJson() => _$UpdateProfileRequestDtoToJson(this);
}
