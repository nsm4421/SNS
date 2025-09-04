import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/repository/feed.repository.dart';

class DeletePostCommentUseCase {
  final FeedRepository _repository;
  final Logger? logger;

  DeletePostCommentUseCase(this._repository, {this.logger});

  Future<Either<Failure, void>> call(String commentId) async {
    return await _repository
        .deletePostComment(commentId)
        .then(
          (res) => res.mapLeft((l) {
            return Failure('댓글삭제 요청 실패');
          }),
        );
  }
}
