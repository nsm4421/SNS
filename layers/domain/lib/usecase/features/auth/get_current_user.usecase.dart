import 'package:domain/entity/features/auth/user.entity.dart';
import 'package:domain/repository/features/auth/auth.repository.dart';
import 'package:either_dart/either.dart';
import 'package:shared/exception/failure/failure.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await _repository.getCurrentUser().thenLeft(
      (l) => Left(Failure.from(l)),
    );
  }
}
