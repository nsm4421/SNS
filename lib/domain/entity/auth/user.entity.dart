import 'package:copy_with_extension/copy_with_extension.dart';

part 'user.entity.g.dart';

@CopyWith(copyWithNull: true)
class UserEntity {
  UserEntity({required this.id, this.username, this.avatarUrl, this.createdAt});

  final String id;
  final String? username;
  final String? avatarUrl;
  final DateTime? createdAt;

  factory UserEntity.from(AppUserEntity e) {
    return UserEntity(
      id: e.id,
      username: e.username,
      avatarUrl: e.avatarUrl,
      createdAt: e.createdAt,
    );
  }
}

@CopyWith(copyWithNull: true)
class AppUserEntity extends UserEntity {
  AppUserEntity({
    required super.id,
    required this.email,
    super.username,
    super.avatarUrl,
    super.createdAt,
  });

  final String email;
}
