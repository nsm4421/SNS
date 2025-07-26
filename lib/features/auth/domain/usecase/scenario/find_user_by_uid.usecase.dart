import 'package:sns/features/auth/domain/entity/user.entity.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';

class FindUserByUidUseCase {
  final AuthRepository _repository;

  FindUserByUidUseCase(this._repository);

  Future<UserEntity?> call(String uid) async {
    return await _repository.findByUid(uid);
  }
}
