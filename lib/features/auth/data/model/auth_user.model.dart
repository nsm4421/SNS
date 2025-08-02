import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/core/constant/user_profile.constant.dart';
import 'package:sns/core/data/model/base.model.dart';

part 'auth_user.model.g.dart';

part 'auth_user.model.freezed.dart';

@freezed
@JsonSerializable()
class AuthUserModel with _$AuthUserModel implements BaseModel {
  final String id;
  final String username;
  final Sex? sex;
  final String? description;
  @JsonKey(name: "created_at")
  final String? createdAt;

  // user model에 추가할 필드
  final String email;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  AuthUserModel({
    required this.id,
    required this.email,
    required this.username,
    this.sex,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);
}
