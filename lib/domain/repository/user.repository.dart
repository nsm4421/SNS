import 'package:either_dart/either.dart';
import 'package:response_wrapper/api_exception/api_error.dart';
import 'package:sns/domain/entity/user/user.entity.dart';

abstract interface class UserRepository {
  Future<Either<ApiError, UserEntity>> findByUid(String uid);
}
