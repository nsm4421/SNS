import 'package:sns/domain/entity/user/user.entity.dart';
import 'package:supabase_datasource/datasources/auth/model/auth_user.model.dart';

extension AuthUserModelExtension on AuthUserModel {
  AuthUserEntity toEntity() {
    return AuthUserEntity(
      id: id,
      username: username,
      email: email,
      profileImage: profileImage,
      createdAt: DateTime.tryParse(createdAt ?? ''),
    );
  }
}