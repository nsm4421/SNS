import 'package:copy_with_extension/copy_with_extension.dart';

import '../base/creator.entity.dart';

part 'user.entity.g.dart';

@CopyWith(copyWithNull: true)
class UserEntity extends CreatorEntity {
  UserEntity({
    required super.id,
    required super.username,
    super.createdAt,
    super.updatedAt,
    super.profileImage,
  });

  factory UserEntity.from(AuthUserEntity a) {
    return UserEntity(
      id: a.id,
      username: a.username,
      createdAt: a.createdAt,
      updatedAt: a.updatedAt,
      profileImage: a.profileImage,
    );
  }
}

@CopyWith(copyWithNull: true)
class AuthUserEntity extends UserEntity {
  AuthUserEntity({
    required super.id,
    required super.username,
    super.createdAt,
    super.updatedAt,
    super.profileImage,
    required this.email,
  });

  final String email;
}
