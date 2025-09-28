import 'package:karma/domain/entity/auth/user.entity.dart';
import 'package:supabase_datasource/supabase_datasource.dart';

extension AppUserMapper on AppUserModel {
  AppUserEntity toEntity() => AppUserEntity(
    id: id,
    email: email,
    username: username,
    avatarUrl: avatarUrl,
    createdAt: createdAt,
  );
}
