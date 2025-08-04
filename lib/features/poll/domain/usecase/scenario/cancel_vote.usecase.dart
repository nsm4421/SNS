part of '../poll.usecases.dart';

class CancelVoteUseCase with ApiErrorToFailureMapperMixIn {
  final PollRepository _repository;

  CancelVoteUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String topicId,
    required String optionId,
  }) async {
    return await _repository
        .deleteVoteByOption(optionId)
        .then(
          (res) => res.fold((l) => Left(handleFailure(l)), (r) => Right(r)),
        );
  }
}
