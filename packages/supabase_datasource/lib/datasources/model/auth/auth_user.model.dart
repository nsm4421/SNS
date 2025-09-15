import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.model.g.dart';

part 'auth_user.model.freezed.dart';

@freezed
@JsonSerializable()
class SupabaseAuthUserModel with _$SupabaseAuthUserModel {
  @JsonKey(name: 'sub')
  final String id;
  final String email;
  final String username;
  @JsonKey(name: "profile_image")
  final String? profileImage;
  @JsonKey(name: "created_at")
  final String? createdAt;

  SupabaseAuthUserModel({
    required this.id,
    required this.email,
    required this.username,
    this.profileImage,
    this.createdAt,
  });

  factory SupabaseAuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$SupabaseAuthUserModelFromJson(json);
}
