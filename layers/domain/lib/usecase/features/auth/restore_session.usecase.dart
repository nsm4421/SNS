import 'package:domain/repository/features/auth/auth.repository.dart';
import 'package:either_dart/either.dart';
import 'package:shared/exception/failure/failure.dart';

class RestoreSessionUseCase {
  final AuthRepository _repository;

  const RestoreSessionUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    final getRefreshTokenRes = await _repository
        .getRefreshTokenFromLocalStorage();
    if (getRefreshTokenRes.isLeft) {
      return Left(Failure('로그인이 필요합니다'));
    }

    final getNewTokensRes = await _repository.getNewTokensByRefreshToken(
      getRefreshTokenRes.right,
    );
    if (getNewTokensRes.isLeft) {
      return Left(Failure('로그인이 필요합니다'));
    }

    final saveTokensRes = await _repository.saveTokensInLocalStorage(
      accessToken: getNewTokensRes.right.$1,
      refreshToken: getNewTokensRes.right.$2,
    );
    if (saveTokensRes.isLeft) {
      return Left(Failure('로그인이 필요합니다'));
    }

    return Right(null);
  }
}
