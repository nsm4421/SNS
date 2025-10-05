import 'package:fpdart/fpdart.dart';
import 'package:karma/domain/entity/auth/user.entity.dart';
import 'package:shared/shared.dart';

abstract interface class AuthRepository {
  Stream<AppUserEntity?> get authStream;

  Future<Either<Failure, AppUserEntity>> signUp({
    required String email,
    required String password,
    String? username,
    String? avatarUrl,
  });

  Future<Either<Failure, AppUserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUserEntity>> getCurrentUser();

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, AppUserEntity>> refreshSession();
}
