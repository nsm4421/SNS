import 'package:sns/features/auth/domain/entity/user.entity.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<String> call({
    required String email,
    required String password,
    required String username,
  }) async {
    final user = UserEntity(
      email: email,
      password: password,
      username: username,
    );
    // TODO : 회원가입처리
    return 'token';
  }
}
