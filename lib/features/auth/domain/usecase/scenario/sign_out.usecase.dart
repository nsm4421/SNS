import 'package:either_dart/either.dart';
import 'package:sns/core/response/api_error.dart';
import 'package:sns/core/response/api_error_to_failure_mapper_mixin.dart';
import 'package:sns/core/response/failure.dart';
import 'package:sns/core/util/logger/sington_logger.util.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';

class SignOutUseCase with AppLogger, ApiErrorToFailureMapperMixIn {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    final signOutRes = await _repository.signOut().thenLeft((l) {
      switch (l.type) {
        case ApiErrorType.unauthorized:
        case ApiErrorType.server:
          return Left(Failure.server('sign out fails'));
        default:
          return Left(handleFailure(l));
      }
    });
    if (signOutRes.isLeft) return signOutRes;

    final clearTokenRes = await _repository.clearTokens();
    if (clearTokenRes.isLeft) {
      logger.w('sign out request success, but removing token fails');
    }

    return const Right(null);
  }
}
