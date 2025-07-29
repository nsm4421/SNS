import 'package:either_dart/either.dart';
import 'package:sns/core/response/api_error.dart';
import 'package:sns/core/response/api_error_to_failure_mapper_mixin.dart';
import 'package:sns/core/response/failure.dart';
import 'package:sns/features/poll/domain/repository/poll.repository.dart';

class GetTopicDetailUseCase with ApiErrorToFailureMapperMixIn {
  final PollRepository _repository;

  GetTopicDetailUseCase(this._repository);

  Future<Either<Failure, void>> call(String topicId) async {
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
