part of '../auth.usecases.dart';

final class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    return await _repository.signOut().then(
      (res) => res.mapLeft((l) => l.copyWith('sign out fails')),
    );
  }
}
