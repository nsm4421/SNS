part of '../auth.usecases.dart';

final class RestoreSessionUseCase {
  final AuthRepository _repository;

  RestoreSessionUseCase(this._repository);

  Future<Either<Failure, AppUserEntity>> call() async {
    return await _repository.restoreSession().then(
      (res) => res.mapLeft((l) => l.copyWith('restore session fails')),
    );
  }
}
