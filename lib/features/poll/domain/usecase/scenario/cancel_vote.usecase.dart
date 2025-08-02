part of '../poll.usecases.dart';

class CancelVoteUseCase with ApiErrorToFailureMapperMixIn {
  final PollRepository _repository;

  CancelVoteUseCase(this._repository);

  Future<Either<Failure, void>> call(String optionId) async {
    final deleteVoteRes = await _repository.deleteVoteByOption(optionId);
    if (deleteVoteRes.isLeft &&
        deleteVoteRes.left.type != ApiErrorType.notFound) {
      return Left(handleFailure(deleteVoteRes.left));
    }

    return const Right(null);
  }
}
