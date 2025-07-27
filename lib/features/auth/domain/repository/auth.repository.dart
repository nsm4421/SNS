import 'package:either_dart/either.dart';
import 'package:sns/core/constant/auth_state.constant.dart';
import 'package:sns/core/constant/user_profile.constant.dart';
import 'package:sns/core/response/failure.dart';
import 'package:sns/features/auth/domain/entity/user.entity.dart';

abstract class AuthRepository {
  Stream<AuthStatus> get authStatusStream;

  Future<bool> getIsAuth();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, UserEntity>> findByUid(String uid);

  Future<Either<Failure, void>> signUp({
    required String email,
    required String password,
    required String username,
  });

  Future<Either<Failure, void>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> restoreSession();

  Future<Either<Failure, void>> editProfile({
    String? username,
    String? description,
    Sex? sex,
  });
}
