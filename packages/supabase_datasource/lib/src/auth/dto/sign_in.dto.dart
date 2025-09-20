import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/models/auth/app_user.model.dart';

part 'sign_in.dto.freezed.dart';

part 'sign_in.dto.g.dart';

@freezed
@JsonSerializable()
class SignInRequestDto with _$SignInRequestDto {
  SignInRequestDto({
    required this.email,
    required this.password,
    this.username,
    this.avatarUrl,
  });

  final String email;
  final String password;
  final String? username;
  final String? avatarUrl;

  factory SignInRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignInRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SignInRequestDtoToJson(this);
}

@freezed
@JsonSerializable()
class SignInResponseDto with _$SignInResponseDto {
  SignInResponseDto({
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

  factory SignInResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SignInResponseDtoToJson(this);
}
