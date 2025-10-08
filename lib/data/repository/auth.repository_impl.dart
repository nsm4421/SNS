import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/data/datasource/datasource.export.dart';
import 'package:karma/data/model/model.export.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/repository/repository.export.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Stream<AppUserEntity?> get authStream =>
      _authDataSource.authStatusStream.asyncMap(
        (e) => e.when(
          signedIn: (accessToken, refreshToken, user) async => user.toEntity(),
          signedOut: () => null,
          tokenRefreshed: (accessToken, refreshToken, user) => user?.toEntity(),
          userUpdated: (user) => user.toEntity(),
          unknown: (message) => null,
        ),
      );

  @override
  Future<Either<Failure, AppUserEntity>> signUp({
    required String email,
    required String password,
    String? username,
    String? avatarUrl,
  }) async {
    try {
      return await _authDataSource
          .signUp(
            email: email,
            password: password,
            username: username,
            avatarUrl: avatarUrl,
          )
          .then((res) => res.user.toEntity())
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, AppUserEntity>> getCurrentUser() async {
    try {
      return await _authDataSource
          .getCurrentUser()
          .then((res) => res.toEntity())
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, AppUserEntity>> refreshSession() async {
    try {
      return await _authDataSource
          .refreshSession()
          .then((res) => res.user.toEntity())
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, AppUserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _authDataSource
          .signIn(email: email, password: password)
          .then((res) => res.user.toEntity())
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      return await _authDataSource.signOut().then((_) => const Right(unit));
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }
}
