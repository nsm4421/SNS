import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/core/core.export.dart';

part 'user.model.freezed.dart';

part 'user.model.g.dart';

@freezed
@JsonSerializable()
class UserModel with _$UserModel implements BaseModel {
  final String id;
  final String username;
  final Sex? sex;
  final String? description;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.username,
    this.sex,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
