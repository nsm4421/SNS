import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/entity/chat/dm_message.entity.dart';
import 'package:sns/domain/repository/dm.repository.dart';

class SendDmMessageUseCase {
  final DmRepository _repository;
  final Logger? logger;

  const SendDmMessageUseCase(this._repository, {this.logger});

  Future<Either<Failure, DmMessageEntity>> call({
    required String conversationId,
    required String content,
  }) async {
    return await _repository
        .createMessage(conversationId: conversationId, content: content)
        .then(
          (res) => res.fold(
            (l) => Left(Failure.conflict('DM을 보낼 수 없습니다')),
            (r) => Right(r),
          ),
        );
  }
}
