import 'package:data/datasource/database/mapper/user.mapper.dart';
import 'package:data/datasource/features/auth/user_table.datasource_impl.dart';
import 'package:domain/entity/features/auth/user.entity.dart';
import 'package:domain/repository/features/auth/user.repository.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/exception/api/api_error.dart';

@LazySingleton(as:UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required UserTableDataSource userTableDataSource})
    : _userTableDataSource = userTableDataSource;

  final UserTableDataSource _userTableDataSource;

  Future<Either<ApiError, UserEntity>> findByUid(String uid) async {
    try {
      return await _userTableDataSource
          .findUserById(uid)
          .then((row) => row.toEntity)
          .then(Right.new);
    } catch (error) {
      return Left(ApiError.from(error));
    }
  }
}
