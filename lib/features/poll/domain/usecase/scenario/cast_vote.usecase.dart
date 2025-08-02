part of '../poll.usecases.dart';

class CastVoteUseCase with ApiErrorToFailureMapperMixIn {
  final PollRepository _repository;

  CastVoteUseCase(this._repository);

  Future<Either<Failure, void>> call(String optionId) async {
    return await _repository
        .upsertVote(optionId)
        .thenLeft((l) => Left(handleFailure(l)));
  }
}
