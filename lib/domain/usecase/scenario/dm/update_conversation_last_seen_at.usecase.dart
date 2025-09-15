import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/repository/dm.repository.dart';

class UpdateDmConversationLastSeenAtUseCase {
  final DmRepository _repository;
  final Logger? logger;

  const UpdateDmConversationLastSeenAtUseCase(this._repository, {this.logger});

  Future<Either<Failure, void>> call(
    String conversationId, {
    DateTime? lastSeenAt,
  }) async {
    return await _repository
        .updateConversationLastSeenAt(conversationId, lastSeenAt: lastSeenAt)
        .then(
          (res) => res.fold(
            (l) => Left(Failure.conflict('대화방 마지막 조회시간 업데이트 실패')),
            (r) => Right(r),
          ),
        );
  }
}
