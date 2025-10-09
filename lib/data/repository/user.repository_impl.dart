import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/data/datasource/datasource.export.dart';
import 'package:karma/data/model/model.export.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/repository/repository.export.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final ProfilesTableDataSource _profilesTableDataSource;
  final UserPresenceDataSource _userPresenceDataSource;
  final RemoteAuthDataSource _remoteAuthDataSource;

  UserRepositoryImpl({
    required ProfilesTableDataSource profilesTableDataSource,
    required UserPresenceDataSource userPresenceDataSource,
    required RemoteAuthDataSource remoteAuthDataSource,
  }) : _profilesTableDataSource = profilesTableDataSource,
       _userPresenceDataSource = userPresenceDataSource,
       _remoteAuthDataSource = remoteAuthDataSource;

  @override
  Stream<Set<String>> getOnlineUserIdsStream(String topic) =>
      _userPresenceDataSource.onlineUserIdsStream(topic);

  @override
  Future<Either<Failure, bool>> getIsUsernameDuplicated(String username) async {
    try {
      return await _profilesTableDataSource
          .getIsUsernameDuplicated(username)
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getById(String userId) async {
    try {
      return await _profilesTableDataSource
          .getByUserId(userId)
          .then((e) => e.toEntity())
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String userId,
    required String username,
    String? displayName,
    String? avatarUrl,
    String? bio,
    String? statusMessage,
  }) async {
    try {
      return await _profilesTableDataSource
          .updateProfile(
            UpdateProfileRequestDto(
              userId: userId,
              username: username,
              displayName: displayName,
              avatarUrl: avatarUrl,
              bio: bio,
              statusMessage: statusMessage,
            ),
          )
          .then((e) => e.toEntity())
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> enterPresence({
    required String topic,
    Map<String, dynamic>? metadata,
    bool includeSelfInState = true,
  }) async {
    try {
      final currentUserId = _remoteAuthDataSource.currentUserId;
      if (currentUserId == null) {
        throw CustomException.auth(message: 'not logged in');
      }
      return await _userPresenceDataSource
          .enter(
            topic: topic,
            userId: currentUserId,
            metadata: metadata,
            includeSelfInState: includeSelfInState,
          )
          .then((_) => const Right(unit));
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> leavePresence(String topic) async {
    try {
      return await _userPresenceDataSource
          .leave(topic)
          .then((_) => const Right(unit));
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> disposePresence() async {
    try {
      return _userPresenceDataSource.clearResources().then(
        (_) => const Right(unit),
      );
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateLastSeenAt(DateTime lastSeenAt) async {
    try {
      final currentUserId = _remoteAuthDataSource.currentUserId;
      if (currentUserId == null) {
        throw CustomException.auth(message: 'not logged in');
      }
      return _profilesTableDataSource
          .updateLastSeenAt(userId: currentUserId, lastSeenAt: lastSeenAt)
          .then((_) => const Right(unit));
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }
}
