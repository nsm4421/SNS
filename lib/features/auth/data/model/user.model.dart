import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/core/constant/user_profile.constant.dart';

part 'user.model.freezed.dart';

part 'user.model.g.dart';

@freezed
@JsonSerializable()
class UserModel with _$UserModel {
  final String id;
  final String username;
  final Sex? sex;
  final String? description;
  @JsonKey(name: "created_at")
  final String? createdAt;

  UserModel({
    required this.id,
    required this.username,
    this.sex,
    this.description,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
