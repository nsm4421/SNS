import 'package:either_dart/either.dart';
import 'package:sns/core/constant/api_error_type.constant.dart';
import 'package:sns/core/util/exception/api_error_to_failure_mapper_mixin.dart';
import 'package:sns/core/util/exception/failure.dart';
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
