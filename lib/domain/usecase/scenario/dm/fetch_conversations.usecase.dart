import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/entity/chat/dm_conversation.entity.dart';
import 'package:sns/domain/repository/dm.repository.dart';

class FetchDmConversationsUseCase {
  final DmRepository _repository;
  final Logger? logger;

  const FetchDmConversationsUseCase(this._repository, {this.logger});

  Future<Either<Failure, Page<DmConversationEntity>>> call({
    required String cursor,
    int limit = 20,
  }) async {
    return await _repository
        .fetchConversations(cursor: cursor, limit: limit)
        .then(
          (res) => res.fold(
            (l) => Left(Failure.conflict('채팅방을 가져올 수 없습니다')),
            (r) => Right(r),
          ),
        );
  }
}
