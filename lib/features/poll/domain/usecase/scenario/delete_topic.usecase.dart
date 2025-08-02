part of '../poll.usecases.dart';

class DeleteTopicUseCase with ApiErrorToFailureMapperMixIn {
  final PollRepository _repository;

  DeleteTopicUseCase(this._repository);

  Future<Either<Failure, void>> call(String topicId) async {
    return await _repository.deleteTopic(topicId).thenLeft((l) {
      return Left(() {
        switch (l.type) {
          case ApiErrorType.notFound:
            return Failure.notFound('topic not found');
          case ApiErrorType.unauthorized:
          case ApiErrorType.forbidden:
            return Failure.notFound('only author can delete own topic');
          default:
            return handleFailure(l);
        }
      }());
    });
  }
}
