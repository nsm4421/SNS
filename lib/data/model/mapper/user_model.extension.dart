import 'package:sns/domain/entity/user/user.entity.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';
import 'package:supabase_datasource/datasources/model/auth/auth_user.model.dart';

extension UserModelExtension on UsersRow {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      profileImage: profileImage,
      createdAt: createdAt,
    );
  }
}

extension SupabaseAuthUserModelExtension on SupabaseAuthUserModel {
  AuthUserEntity toEntity() {
    return AuthUserEntity(
      id: id,
      username: username,
      profileImage: profileImage,
      createdAt: createdAt == null ? null : DateTime.tryParse(createdAt!),
      email: email,
    );
  }
}
