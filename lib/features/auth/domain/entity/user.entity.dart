import 'package:sns/core/constant/user_profile.constant.dart';
import 'package:sns/features/auth/data/model/auth_user.model.dart';
import 'package:sns/features/auth/data/model/user.model.dart';

class UserEntity {
  final String id;
  final String username;
  final Sex? sex;
  final String? description;
  final DateTime? createdAt;
  final String? email;
  final DateTime? updatedAt;

  UserEntity({
    required this.id,
    required this.username,
    this.sex,
    this.description,
    this.createdAt,
    this.email,
    this.updatedAt,
  });

  factory UserEntity.fromUserModel(UserModel model) {
    return UserEntity(
      id: model.id,
      username: model.username,
      sex: model.sex,
      description: model.description,
      createdAt: DateTime.tryParse(model.createdAt ?? ''),
    );
  }

  factory UserEntity.fromAuthUserModel(AuthUserModel model) {
    return UserEntity(
      id: model.id,
      username: model.username,
      sex: model.sex,
      description: model.description,
      email: model.username,
      createdAt: DateTime.tryParse(model.createdAt ?? ''),
      updatedAt: DateTime.tryParse(model.updatedAt ?? ''),
    );
  }
}
