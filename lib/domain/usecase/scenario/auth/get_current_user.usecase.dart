import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/core/extension/logger.extension.dart';
import 'package:sns/domain/entity/user/user.entity.dart';
import 'package:sns/domain/repository/auth.repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;
  final Logger? logger;

  const GetCurrentUserUseCase(this._repository, {this.logger});

  Future<Either<Failure, UserEntity>> call() async {
    return await _repository.getCurrentUser().thenLeft((l) {
      logger?.logApiError(l);
      return Left(Failure.from(l));
    });
  }
}
