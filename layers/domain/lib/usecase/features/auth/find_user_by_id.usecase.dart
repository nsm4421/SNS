import 'package:domain/domain.dart';
import 'package:domain/entity/features/auth/user.entity.dart';
import 'package:either_dart/either.dart';
import 'package:shared/exception/failure/failure.dart';

class FindUserByUidUseCase {
  final UserRepository _repository;

  const FindUserByUidUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(String uid) async {
    return await _repository
        .findByUid(uid)
        .thenLeft((l) => Left(Failure.from(l)));
  }
}
