import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.model.g.dart';

part 'auth_user.model.freezed.dart';

@freezed
@JsonSerializable()
class AuthUserModel with _$AuthUserModel {
  @JsonKey(name: 'sub')
  final String id;
  final String email;
  final String username;
  @JsonKey(name: "profile_image")
  final String? profileImage;
  @JsonKey(name: "created_at")
  final String? createdAt;

  AuthUserModel({
    required this.id,
    required this.email,
    required this.username,
    this.profileImage,
    this.createdAt,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);
}
