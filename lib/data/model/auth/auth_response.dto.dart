import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:karma/data/model/auth/app_user.model.dart';

part 'auth_response.dto.freezed.dart';

part 'auth_response.dto.g.dart';

@freezed
@JsonSerializable()
class AuthResponseDto with _$AuthResponseDto {
  AuthResponseDto({
    required this.user,
    this.needsEmailConfirmation = false,
    this.accessToken,
    this.refreshToken,
  });

  final AppUserModel user;
  @JsonKey(name: 'need_email_confirmation')
  final bool needsEmailConfirmation;
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseDtoToJson(this);
}
