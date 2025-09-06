import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/repository/feed.repository.dart';

class CreatePostCommentUseCase {
  final FeedRepository _repository;
  final Logger? logger;

  CreatePostCommentUseCase(this._repository, {this.logger});

  Future<Either<Failure, String>> call({
    required String postId,
    String? parentId,
    required String content,
  }) async {
    return await (parentId == null
            ? _repository.createParentPostComment(
                postId: postId,
                content: content,
              )
            : _repository.createChildPostComment(
                postId: postId,
                parentId: parentId!,
                content: content,
              ))
        .then(
          (res) => res.mapLeft((l) {
            return Failure('댓글작성 요청 실패');
          }),
        );
  }
}
