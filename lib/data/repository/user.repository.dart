import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/response_wrapper/api_response/api_error.dart';
import 'package:sns/core/logger/app_logger.dart';
import 'package:sns/data/model/mapper/user_model.extension.dart';
import 'package:sns/domain/entity/user/user.entity.dart';
import 'package:sns/domain/repository/user.repository.dart';
import 'package:supabase_datasource/datasources/database/features/user/user.datasource_impl.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl with AppLogger implements UserRepository {
  UserRepositoryImpl({required UserDataSource userTableDataSource})
    : _userTableDataSource = userTableDataSource;

  final UserDataSource _userTableDataSource;

  @override
  Future<Either<ApiError, UserEntity>> findByUid(String uid) async {
    try {
      return await _userTableDataSource
          .findUserById(uid)
          .then((row) => row.toEntity())
          .then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }
}
