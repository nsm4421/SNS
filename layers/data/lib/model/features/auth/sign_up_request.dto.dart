import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_request.dto.g.dart';

part 'sign_up_request.dto.freezed.dart';

@freezed
@JsonSerializable()
class SignUpRequestDto with _$SignUpRequestDto {
  final String email;
  final String password;
  final String username;
  @JsonKey(name: "profile_image")
  final String? profileImage;

  SignUpRequestDto({
    required this.email,
    required this.password,
    required this.username,
    this.profileImage,
  });

  Map<String, dynamic> get data => {
    'username': this.username,
    if (this.profileImage != null) 'profile_image': profileImage,
  };
}
