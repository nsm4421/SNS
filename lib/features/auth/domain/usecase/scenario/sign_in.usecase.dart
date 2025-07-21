import 'package:sns/features/auth/domain/repository/auth.repository.dart';

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<void> call({required String email, required String password}) async {
    return await _repository.signIn(email: email, password: password);
  }
}
