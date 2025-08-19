import 'package:sns/domain/entity/user/user.entity.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';

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
