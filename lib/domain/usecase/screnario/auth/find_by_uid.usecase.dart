import 'package:either_dart/either.dart';
import 'package:response_wrapper/failure/failure.dart';
import 'package:sns/domain/entity/user/user.entity.dart';
import 'package:sns/domain/repository/user.repository.dart';

class FindUserByUidUseCase {
  final UserRepository _repository;

  const FindUserByUidUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(String uid) async {
    return await _repository
        .findByUid(uid)
        .thenLeft((l) => Left(Failure.from(l)));
  }
}
