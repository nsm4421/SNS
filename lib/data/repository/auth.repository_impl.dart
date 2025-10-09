import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/data/datasource/datasource.export.dart';
import 'package:karma/data/model/model.export.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/repository/repository.export.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final LocalTokenDataSource _localTokenDataSource;
  final RemoteAuthDataSource _authDataSource;

  AuthRepositoryImpl(this._localTokenDataSource, this._authDataSource);

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
      final res = await _authDataSource.signUp(
        email: email,
        password: password,
        username: username,
        avatarUrl: avatarUrl,
      );
      await _trySaveTokens(res.accessToken, res.refreshToken);
      return Right(res.user.toEntity());
    } catch (e, st) {
      appLogger.e('[AuthRepositoryImpl]signUp', error: e, stackTrace: st);
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
    } catch (e, st) {
      appLogger.e(
        '[AuthRepositoryImpl]getCurrentUser',
        error: e,
        stackTrace: st,
      );
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, AppUserEntity>> restoreSession() async {
    try {
      final refreshToken = await _tryGetRefreshToken();
      final res = await _authDataSource.restoreSession(refreshToken);
      await _trySaveTokens(res.accessToken, res.refreshToken);
      return Right(res.user.toEntity());
    } catch (e, st) {
      appLogger.e(
        '[AuthRepositoryImpl]restoreSession',
        error: e,
        stackTrace: st,
      );
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, AppUserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _authDataSource.signIn(
        email: email,
        password: password,
      );
      await _trySaveTokens(res.accessToken, res.refreshToken);
      return Right(res.user.toEntity());
    } catch (e, st) {
      appLogger.e('[AuthRepositoryImpl]signIn', error: e, stackTrace: st);
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _authDataSource.signOut();
      await _tryClearTokens();
      return const Right(unit);
    } catch (e, st) {
      appLogger.e('[AuthRepositoryImpl]signOut', error: e, stackTrace: st);
      return Left(Failure.fromObj(e));
    }
  }

  Future<String?> _tryGetRefreshToken() async {
    try {
      return await _localTokenDataSource.getRefreshToken();
    } catch (e, st) {
      appLogger.w(
        '[AuthRepositoryImpl]_tryGetRefreshToken',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<void> _trySaveTokens(String? accessToken, String? refreshToken) async {
    try {
      await _localTokenDataSource.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } catch (e, st) {
      appLogger.w(
        '[AuthRepositoryImpl]_trySaveTokens',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> _tryClearTokens() async {
    try {
      await _localTokenDataSource.clearTokens();
    } catch (e, st) {
      appLogger.w(
        '[AuthRepositoryImpl]_tryClearTokens',
        error: e,
        stackTrace: st,
      );
    }
  }
}
