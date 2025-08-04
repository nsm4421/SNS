part of '../poll.usecases.dart';

class GetTopicDetailUseCase with ApiErrorToFailureMapperMixIn {
  final PollRepository _repository;

  GetTopicDetailUseCase(this._repository);

  Future<Either<Failure, TopicDetailEntity>> call(String topicId) async {
    return await _repository.getTopicDetail(topicId).thenLeft((l) {
      return Left(() {
        switch (l.type) {
          case ApiErrorType.notFound:
            return Failure.notFound('topic not found');
          default:
            return handleFailure(l);
        }
      }());
    });
  }
}
