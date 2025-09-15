import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/entity/chat/dm_conversation.entity.dart';
import 'package:sns/domain/entity/chat/dm_message.entity.dart';
import 'package:sns/domain/repository/dm.repository.dart';

class FetchDmMessagesUseCase {
  final DmRepository _repository;
  final Logger? logger;

  const FetchDmMessagesUseCase(this._repository, {this.logger});

  Future<Either<Failure, Page<DmMessageEntity>>> call({
    required String conversationId,
    required String cursor,
    int limit = 20,
  }) async {
    return await _repository
        .fetchMessages(
          conversationId: conversationId,
          cursor: cursor,
          limit: limit,
        )
        .then(
          (res) => res.fold(
            (l) => Left(Failure.conflict('메시지 목록을 가져올 수 없습니다')),
            (r) => Right(r),
          ),
        );
  }
}
