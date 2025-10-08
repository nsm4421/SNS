import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/data/datasource/datasource.export.dart';
import 'package:karma/data/model/model.export.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/repository/repository.export.dart';

@LazySingleton(as: DmRepository)
class DmRepositoryImpl implements DmRepository {
  final DmDataSource _dmDataSource;
  final DmRealtimeManager _dmRealtimeManager;

  DmRepositoryImpl({
    required DmDataSource dmDataSource,
    required DmRealtimeManager dmRealtimeManager,
  }) : _dmDataSource = dmDataSource,
       _dmRealtimeManager = dmRealtimeManager;

  @override
  Either<Failure, ChatRoomChannel> getChatRoomChannel(String roomId) {
    try {
      final channel = _dmRealtimeManager.getRoomChannel(roomId);
      return Right(channel);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, DmRoomEntity>> createOrGetRoom(
    String counterpartId,
  ) async {
    try {
      return await _dmDataSource
          .createOrGetRoom(counterpartId)
          .then((res) => res.toEntity())
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Pageable<DmRoomEntity>>> fetchRooms({
    required String cursor,
    int limit = 30,
  }) async {
    try {
      return await _dmDataSource
          .fetchRooms(cursor: cursor, limit: limit)
          .then((res) => res.convert((e) => e.toEntity()))
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Pageable<DmMessageEntity>>> fetchMessages({
    required String roomId,
    required String cursor,
    int limit = 30,
  }) async {
    try {
      return await _dmDataSource
          .fetchMessages(roomId: roomId, cursor: cursor, limit: limit)
          .then((res) => res.convert((e) => e.toEntity()))
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, DmMessageEntity>> sendTextMessage({
    required String roomId,
    required String content,
  }) async {
    try {
      return await _dmDataSource
          .sendTextMessage(roomId: roomId, content: content)
          .then((e) => e.toEntity())
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead({
    required String roomId,
    required String lastReadMessageId,
  }) async {
    try {
      return await _dmDataSource
          .markAsRead(roomId: roomId, lastReadMessageId: lastReadMessageId)
          .then((_) => const Right(unit));
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }
}
