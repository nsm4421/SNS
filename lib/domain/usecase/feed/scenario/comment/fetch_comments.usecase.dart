part of '../../feed.usecaes.dart';

final class FetchCommentsUseCase {
  final FeedRepository _repository;

  FetchCommentsUseCase(this._repository);

  Future<Either<Failure, Pageable<PostCommentEntityWithAuthor>>> call({
    required String postId,
    required String cursor,
    int limit = 30,
  }) async {
    return await _repository
        .fetchComments(postId: postId, cursor: cursor)
        .then((res) => res.mapLeft((l) => l.copyWith('fetching comments fails')));
  }
}
