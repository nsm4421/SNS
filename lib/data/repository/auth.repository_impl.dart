import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/domain/entity/auth/user.entity.dart';
import 'package:karma/domain/repository/auth.repository.dart';
import 'package:shared/shared.dart';
import 'package:supabase_datasource/supabase_datasource.dart';
import 'package:karma/data/mapper/user_entity.mapper.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

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
            SignUpRequestDto(
              email: email,
              password: password,
              username: username,
              avatarUrl: avatarUrl,
            ),
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
          .signIn(SignInRequestDto(email: email, password: password))
          .then((res) => res.user.toEntity())
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      return await _authDataSource.signOut().then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }
}
