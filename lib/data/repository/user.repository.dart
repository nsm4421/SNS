import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:response_wrapper/api_exception/api_error.dart';
import 'package:sns/data/model/mapper/user_model.extension.dart';
import 'package:sns/domain/entity/user/user.entity.dart';
import 'package:sns/domain/repository/user.repository.dart';
import 'package:supabase_datasource/datasources/database/user/user_table.datasource.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required UserTableDataSource userTableDataSource})
    : _userTableDataSource = userTableDataSource;

  final UserTableDataSource _userTableDataSource;

  @override
  Future<Either<ApiError, UserEntity>> findByUid(String uid) async {
    try {
      return await _userTableDataSource
          .findUserById(uid)
          .then((row) => row.toEntity())
          .then(Right.new);
    } catch (error) {
      return Left(ApiError.fromError(error));
    }
  }
}
