import 'package:either_dart/either.dart';
import 'package:sns/core/util/exception/api_error_to_failure_mapper_mixin.dart';
import 'package:sns/core/util/exception/failure.dart';
import 'package:sns/features/poll/domain/entity/topic.entity.dart';
import 'package:sns/features/poll/domain/repository/poll.repository.dart';

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
