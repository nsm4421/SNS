import 'package:sns/features/auth/domain/repository/auth.repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<void> call({
    required String email,
    required String password,
    required String username,
  }) async {
    await _repository.signUp(
      email: email,
      password: password,
      username: username,
    );
  }
}
