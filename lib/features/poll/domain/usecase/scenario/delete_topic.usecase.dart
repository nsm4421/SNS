import 'package:either_dart/either.dart';
import 'package:sns/core/response/api_error.dart';
import 'package:sns/core/response/api_error_to_failure_mapper_mixin.dart';
import 'package:sns/core/response/failure.dart';
import 'package:sns/features/poll/domain/repository/poll.repository.dart';

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
