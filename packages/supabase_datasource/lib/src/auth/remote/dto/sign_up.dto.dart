import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/models/auth/app_user.model.dart';

part 'sign_up.dto.freezed.dart';

part 'sign_up.dto.g.dart';

@freezed
@JsonSerializable()
class SignUpRequestDto with _$SignUpRequestDto {
  SignUpRequestDto({
    required this.email,
    required this.password,
    this.username,
    this.avatarUrl,
  });

  final String email;
  final String password;
  final String? username;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  factory SignUpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestDtoToJson(this);
}

@freezed
@JsonSerializable()
class SignUpResponseDto with _$SignUpResponseDto {
  SignUpResponseDto({
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

  factory SignUpResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseDtoToJson(this);
}
