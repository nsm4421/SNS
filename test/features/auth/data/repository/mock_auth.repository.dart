import 'package:sns/features/auth/domain/entity/user.entity.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';

class MockAuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> signUp({required UserEntity user}) async{
    return 'token';
  }
}
