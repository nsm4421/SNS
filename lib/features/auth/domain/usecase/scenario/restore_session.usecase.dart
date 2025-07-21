import 'package:sns/features/auth/domain/repository/auth.repository.dart';

class RestoreSessionUseCase {
  final AuthRepository _repository;

  RestoreSessionUseCase(this._repository);

  Future<void> call() async {
    await _repository.restoreSession();
  }
}
