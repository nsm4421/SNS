part of '../poll.usecases.dart';

class FetchTopicsUseCase with ApiErrorToFailureMapperMixIn {
  final PollRepository _repository;

  FetchTopicsUseCase(this._repository);

  Future<Either<Failure, List<TopicEntity>>> call({
    int limit = 20,
    DateTime? cursor,
    String? search,
  }) async {
    return await _repository
        .fetchTopics(limit: limit, cursor: cursor, search: search)
        .thenLeft((l) => Left(handleFailure(l)));
  }
}
