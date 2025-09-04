import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/entity/feed/post_comment.entity.dart';
import 'package:sns/domain/repository/feed.repository.dart';

class FetchPostCommentsUseCase {
  final FeedRepository _repository;
  final Logger? logger;

  FetchPostCommentsUseCase(this._repository, {this.logger});

  Future<Either<Failure, Page<PostCommentEntity>>> call({
    required String postId,
    String? parentId,
    required String cursor,
    int limit = 20,
  }) async {
    return await (parentId == null
            ? _repository.fetchParentPostComments(
                postId: postId,
                cursor: cursor,
                limit: limit,
              )
            : _repository.fetchChildPostComments(
                postId: postId,
                cursor: cursor,
                limit: limit,
                parentId: parentId,
              ))
        .then(
          (res) => res.mapLeft((l) {
            return Failure('댓글 조회 중 오류가 발생했습니다');
          }),
        );
  }
}
