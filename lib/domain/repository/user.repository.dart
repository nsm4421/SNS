import 'package:fpdart/fpdart.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/domain/entity/entity.export.dart';

abstract interface class UserRepository {
  Stream<Set<String>> getOnlineUserIdsStream(String topic);

  Future<Either<Failure, UserEntity>> getById(String userId);

  Future<Either<Failure, UserEntity>> updateProfile({
    required String userId,
    required String username,
    String? displayName,
    String? avatarUrl,
    String? bio,
    String? statusMessage,
  });

  Future<Either<Failure, Unit>> enterPresence({
    required String topic,
    Map<String, dynamic>? metadata,
    bool includeSelfInState = true,
  });

  Future<Either<Failure, Unit>> leavePresence(String topic);

  Future<Either<Failure, Unit>> disposePresence();
}
