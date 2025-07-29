import 'package:either_dart/either.dart';
import 'package:sns/core/response/api_error_to_failure_mapper_mixin.dart';
import 'package:sns/core/response/failure.dart';
import 'package:sns/features/poll/domain/repository/poll.repository.dart';

class CastVoteUseCase with ApiErrorToFailureMapperMixIn {
  final PollRepository _repository;

  CastVoteUseCase(this._repository);

  Future<Either<Failure, void>> call(String optionId) async {
    return await _repository
        .upsertVote(optionId)
        .thenLeft((l) => Left(handleFailure(l)));
  }
}
