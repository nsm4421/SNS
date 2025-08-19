import 'package:either_dart/either.dart';
import 'package:response_wrapper/failure/failure.dart';
import 'package:sns/domain/entity/user/user.entity.dart';
import 'package:sns/domain/repository/auth.repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await _repository.getCurrentUser().thenLeft(
      (l) => Left(Failure.from(l)),
    );
  }
}
