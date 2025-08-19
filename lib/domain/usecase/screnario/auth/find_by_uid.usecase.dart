import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/core/extension/logger.extension.dart';
import 'package:sns/domain/entity/user/user.entity.dart';
import 'package:sns/domain/repository/user.repository.dart';

class FindUserByUidUseCase {
  final UserRepository _repository;
  final Logger? logger;

  const FindUserByUidUseCase(this._repository, {this.logger});

  Future<Either<Failure, UserEntity>> call(String uid) async {
    return await _repository.findByUid(uid).thenLeft((l) {
      logger?.logApiError(l);
      return Left(Failure.from(l));
    });
  }
}
