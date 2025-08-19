import 'package:either_dart/either.dart';
import 'package:response_wrapper/failure/failure.dart';
import 'package:sns/domain/repository/auth.repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;

  const SignOutUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    final signOutRes = await _repository.signOut();
    if (signOutRes.isLeft) {
      return Left(Failure('로그아웃 도중 오류가 발생했습니다'));
    }

    final deleteTokenRes = await _repository.deleteTokensInLocalStorage();
    if (deleteTokenRes.isLeft) {
      return Left(Failure('로그아웃 도중 오류가 발생했습니다'));
    }
    return Right(null);
  }
}
