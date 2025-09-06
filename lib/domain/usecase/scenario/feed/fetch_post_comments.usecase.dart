import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/entity/feed/post_comment.entity.dart';
import 'package:sns/domain/repository/feed.repository.dart';

abstract class FetchPostCommentsUseCase {
  final FeedRepository _repository;
  final Logger? logger;

  FetchPostCommentsUseCase(this._repository, {this.logger});
}

class FetchParentPostCommentsUseCase extends FetchPostCommentsUseCase {
  FetchParentPostCommentsUseCase(super.repository, {super.logger});

  Future<Either<Failure, Page<ParentPostCommentEntity>>> call({
    required String cursor,
    int limit = 20,
    required String postId,
  }) async {
    return await _repository
        .fetchParentPostComments(postId: postId, cursor: cursor, limit: limit)
        .then(
          (res) => res.mapLeft((l) {
            return Failure('댓글 조회 중 오류가 발생했습니다');
          }),
        );
  }
}

class FetchChildPostCommentsUseCase extends FetchPostCommentsUseCase {
  FetchChildPostCommentsUseCase(super.repository, {super.logger});

  Future<Either<Failure, Page<ChildPostCommentEntity>>> call({
    required String postId,
    required String parentId,
    required String cursor,
    int limit = 20,
  }) async {
    return await _repository
        .fetchChildPostComments(
          postId: postId,
          parentId: parentId,
          cursor: cursor,
          limit: limit,
        )
        .then(
          (res) => res.mapLeft((l) {
            return Failure('댓글 조회 중 오류가 발생했습니다');
          }),
        );
  }
}
