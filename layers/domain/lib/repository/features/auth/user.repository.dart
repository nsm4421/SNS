import 'package:domain/entity/features/auth/user.entity.dart';
import 'package:either_dart/either.dart';
import 'package:shared/exception/api/api_error.dart';

abstract interface class UserRepository {
  Future<Either<ApiError, UserEntity>> findByUid(String uid);
}
