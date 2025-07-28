import 'package:either_dart/either.dart';
import 'package:sns/core/response/api_error.dart';
import 'package:sns/core/response/api_error_to_failure_mapper_mixin.dart';
import 'package:sns/core/response/failure.dart';
import 'package:sns/features/auth/domain/entity/user.entity.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';

class GetCurrentUserUseCase with ApiErrorToFailureMapperMixIn {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await _repository.getCurrentUser().thenLeft((l) {
      return Left(() {
        switch (l.type) {
          case ApiErrorType.unauthorized:
          case ApiErrorType.notFound:
            return Failure.unAuthorized();
          default:
            return handleFailure(l);
        }
      }());
    });
  }
}
