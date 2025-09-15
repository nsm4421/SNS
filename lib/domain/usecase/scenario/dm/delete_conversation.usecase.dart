import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/repository/dm.repository.dart';

class DeleteConversationUseCase {
  final DmRepository _repository;
  final Logger? logger;

  const DeleteConversationUseCase(this._repository, {this.logger});

  Future<Either<Failure, void>> call(String conversationId) async {
    return await _repository
        .deleteConversation(conversationId)
        .then(
          (res) => res.fold(
            (l) => Left(Failure.conflict('대화방을 삭제할 수 없습니다')),
            (r) => Right(r),
          ),
        );
  }
}
