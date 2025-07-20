import 'package:sns/features/auth/domain/entity/user.entity.dart';

abstract interface class AuthRepository {
  Future<String> signUp({required UserEntity user});
}
