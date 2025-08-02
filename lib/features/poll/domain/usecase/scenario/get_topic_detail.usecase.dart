import 'package:either_dart/either.dart';
import 'package:sns/core/constant/api_error_type.constant.dart';
import 'package:sns/core/util/exception/api_error_to_failure_mapper_mixin.dart';
import 'package:sns/core/util/exception/failure.dart';
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
