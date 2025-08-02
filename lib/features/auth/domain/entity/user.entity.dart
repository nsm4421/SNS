import 'package:sns/core/core.export.dart';
import 'package:sns/features/auth/data/model/auth_user.model.dart';
import 'package:sns/features/auth/data/model/user.model.dart';

class UserEntity extends BaseEntity implements CreatorEntity {
  final String username;
  final Sex? sex;
  final String? description;
  final DateTime? createdAt;
  final String? email;
  final DateTime? updatedAt;

  UserEntity({
    required super.id,
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
      updatedAt: DateTime.tryParse(model.updatedAt ?? ''),
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
