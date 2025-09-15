import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/export.dart';
import 'package:sns/core/logger/app_logger.dart';
import 'package:sns/data/model/mapper/dm_conversation_row.extension.dart';
import 'package:sns/data/model/mapper/dm_message_row.extension.dart';
import 'package:sns/domain/entity/chat/dm_conversation.entity.dart';
import 'package:sns/domain/entity/chat/dm_message.entity.dart';
import 'package:sns/domain/repository/dm.repository.dart';
import 'package:supabase_datasource/datasources/auth/auth.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/features/chat/dm/dm.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';

@LazySingleton(as: DmRepository)
class DmRepositoryImpl with AppLogger implements DmRepository {
  late final String _currentUid;
  final SupabaseDirectMessageDataSource _directMessageDataSource;

  DmRepositoryImpl({
    required SupabaseAuthDataSource authDataSource,
    required SupabaseDirectMessageDataSource directMessageDataSource,
  }) : _directMessageDataSource = directMessageDataSource {
    _currentUid = authDataSource.currentUid!;
  }

  @override
  Stream<StreamPayloadWrapper<DmConversationEntity>> getConversationStream() {
    return _directMessageDataSource.realtime.genConversationChannel().asyncMap((
      e,
    ) async {
      try {
        if (e.event == StreamEvent.insert) {
          return await _directMessageDataSource.conversation
              .findConversationWithUserById(
                (e as StreamPayloadInserted).inserted.id,
              )
              .then((r) => r?.toEntity())
              .then(
                (res) => res == null
                    ? StreamPayloadError<DmConversationEntity>()
                    : StreamPayloadInserted<DmConversationEntity>(
                        inserted: res,
                      ),
              );
        } else if (e.event == StreamEvent.update) {
          return await _directMessageDataSource.conversation
              .findConversationWithUserById(
                (e as StreamPayloadUpdated).updated.id,
              )
              .then((r) => r?.toEntity())
              .then(
                (res) => res == null
                    ? StreamPayloadError<DmConversationEntity>()
                    : StreamPayloadUpdated<DmConversationEntity>(updated: res),
              );
        } else if (e.event == StreamEvent.delete) {
          return StreamPayloadDeleted<DmConversationEntity>(
            deleted: (e as StreamPayloadDeleted).deleted,
          );
        }
        return StreamPayloadError<DmConversationEntity>();
      } catch (error) {
        logger.e(error);
        return StreamPayloadError<DmConversationEntity>();
      }
    });
  }

  @override
  Stream<StreamPayloadWrapper<DmMessageEntity>> getMessageStream(
    String conversationId,
  ) {
    return _directMessageDataSource.realtime
        .getMessageChannel(conversationId)
        .asyncMap((e) async {
          try {
            if (e.event == StreamEvent.insert) {
              return StreamPayloadInserted<DmMessageEntity>(
                inserted: (e as StreamPayloadInserted<DmMessagesRow>).inserted
                    .toEntity(),
              );
            } else if (e.event == StreamEvent.update) {
              return StreamPayloadUpdated<DmMessageEntity>(
                updated: (e as StreamPayloadUpdated<DmMessagesRow>).updated
                    .toEntity(),
              );
            } else if (e.event == StreamEvent.delete) {
              return StreamPayloadDeleted<DmMessageEntity>(
                deleted: (e as StreamPayloadDeleted<DmMessagesRow>).deleted,
              );
            }
            return StreamPayloadError<DmMessageEntity>();
          } catch (error) {
            logger.e(error);
            return StreamPayloadError<DmMessageEntity>();
          }
        });
  }

  @override
  Future<Either<ApiError, String>> getConversationByOtherUid(
    String otherUid,
  ) async {
    try {
      return await _directMessageDataSource.conversation
          .getOrCreateConversation(otherUid)
          .then((res) => res.id)
          .then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, Page<DmConversationEntity>>> fetchConversations({
    required String cursor,
    int limit = 20,
  }) async {
    try {
      return await _directMessageDataSource.conversation
          .fetchConversations(cursor: cursor, limit: limit)
          .then((res) => res.convert((e) => e.toEntity()))
          .then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, void>> updateConversationLastSeenAt(
    String conversationId, {
    DateTime? lastSeenAt,
  }) async {
    try {
      return await _directMessageDataSource.conversation
          .updateLastSeenAt(
            conversationId: conversationId,
            userId: _currentUid,
            lastSeenAt: lastSeenAt ?? DateTime.now().toUtc(),
          )
          .then((_) => const Right(null));
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, void>> deleteConversation(
    String conversationId,
  ) async {
    try {
      return await _directMessageDataSource.conversation
          .deleteConversationById(conversationId)
          .then((_) => const Right(null));
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, DmMessageEntity>> createMessage({
    required String conversationId,
    required String content,
  }) async {
    try {
      return await _directMessageDataSource.message
          .createDirectMessage(conversationId: conversationId, content: content)
          .then((res) => res.toEntity())
          .then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, Page<DmMessageEntity>>> fetchMessages({
    required conversationId,
    required String cursor,
    int limit = 20,
  }) async {
    try {
      return await _directMessageDataSource.message
          .fetchDirectMessages(
            conversationId: conversationId,
            cursor: cursor,
            limit: limit,
          )
          .then((res) => res.convert((e) => e.toEntity()))
          .then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, void>> deleteMessage(String messageId) async {
    try {
      return await _directMessageDataSource.message
          .deleteDirectMessageById(messageId)
          .then((_) => const Right(null));
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }
}
