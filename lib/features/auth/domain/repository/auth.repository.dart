import 'package:sns/core/constant/auth_state.constant.dart';
import 'package:sns/core/constant/user_profile.constant.dart';
import 'package:sns/features/auth/domain/entity/user.entity.dart';

abstract class AuthRepository {
  Stream<AuthStatus> get authStatusStream;

  Future<bool> getIsAuth();

  Future<UserEntity> getCurrentUser();

  Future<UserEntity?> findByUid(String uid);

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  });

  Future<void> signIn({required String email, required String password});

  Future<void> signOut();

  Future<void> restoreSession();

  Future<void> editProfile({String? username, String? description, Sex? sex});
}
