part of '../../feed.usecaes.dart';

final class FetchPostsUseCase {
  final FeedRepository _repository;

  FetchPostsUseCase(this._repository);

  Future<Either<Failure, Pageable<FeedPostEntityWithAuthor>>> call({
    required String cursor,
    int limit = 30,
  }) async {
    return await _repository
        .fetchFeeds(cursor: cursor, limit: limit)
        .then((res) => res.mapLeft((l) => l.copyWith('fetching posts failed')));
  }
}
