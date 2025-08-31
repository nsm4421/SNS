import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/core/extension/logger.extension.dart';
import 'package:sns/domain/repository/auth.repository.dart';

class RestoreSessionUseCase {
  final AuthRepository _repository;
  final Logger? logger;

  const RestoreSessionUseCase(this._repository, {this.logger});

  Future<Either<Failure, void>> call() async {
    final getRefreshTokenRes = await _repository
        .getRefreshTokenFromLocalStorage();
    if (getRefreshTokenRes.isLeft) {
      logger?.logApiError(getRefreshTokenRes.left);
      return Left(Failure('로그인이 필요합니다'));
    }

    final getNewTokensRes = await _repository.getNewTokensByRefreshToken(
      getRefreshTokenRes.right,
    );
    if (getNewTokensRes.isLeft) {
      logger?.logApiError(getNewTokensRes.left);
      return Left(Failure('로그인이 필요합니다'));
    }

    final saveTokensRes = await _repository.saveTokensInLocalStorage(
      accessToken: getNewTokensRes.right.$1,
      refreshToken: getNewTokensRes.right.$2,
    );
    if (saveTokensRes.isLeft) {
      logger?.logApiError(saveTokensRes.left);
      return Left(Failure('로그인이 필요합니다'));
    }

    return const Right(null);
  }
}
