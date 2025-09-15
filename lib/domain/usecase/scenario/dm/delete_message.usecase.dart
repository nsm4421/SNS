import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/repository/dm.repository.dart';

class DeleteMessageUseCase {
  final DmRepository _repository;
  final Logger? logger;

  const DeleteMessageUseCase(this._repository, {this.logger});

  Future<Either<Failure, void>> call(String messageId) async {
    return await _repository
        .deleteMessage(messageId)
        .then(
          (res) => res.fold(
            (l) => Left(Failure.conflict('DM를 삭제할 수 없습니다')),
            (r) => Right(r),
          ),
        );
  }
}
