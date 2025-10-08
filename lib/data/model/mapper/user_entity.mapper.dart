import 'package:karma/data/model/auth/app_user.model.dart';
import 'package:karma/data/model/profile/profile.model.dart';
import 'package:karma/domain/entity/auth/user.entity.dart';

extension AppUserMapper on AppUserModel {
  AppUserEntity toEntity() => AppUserEntity(
    id: id,
    email: email,
    username: username,
    avatarUrl: avatarUrl,
    createdAt: createdAt,
  );
}

extension ProfileMapper on ProfileModel {
  UserEntity toEntity() {
    return UserEntity(
      id: userId,
      username: username,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
    );
  }
}
