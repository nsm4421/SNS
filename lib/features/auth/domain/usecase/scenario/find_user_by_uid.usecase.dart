import 'package:either_dart/either.dart';
import 'package:sns/core/response/api_error.dart';
import 'package:sns/core/response/api_error_to_failure_mapper_mixin.dart';
import 'package:sns/core/response/failure.dart';
import 'package:sns/features/auth/domain/entity/user.entity.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';

class FindUserByUidUseCase with ApiErrorToFailureMapperMixIn{
  final AuthRepository _repository;

  FindUserByUidUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(String uid) async {
    return await _repository.findByUid(uid).thenLeft((l) {
      if (l.type == ApiErrorType.notFound) {
        return Left(Failure('user not found'));
      }
      return Left(handleFailure(l));
    });
  }
}
