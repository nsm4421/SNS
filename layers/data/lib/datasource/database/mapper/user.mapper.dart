import 'package:data/datasource/database/database.dart';
import 'package:domain/entity/features/auth/user.entity.dart';

extension UsersRowExtension on UsersRow {
  UserEntity get toEntity => UserEntity(
    id: this.id,
    username: this.username,
    createdAt: this.createdAt,
    profileImage: this.profileImage,
  );
}
