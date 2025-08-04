part of '../poll.usecases.dart';

class CancelVoteUseCase with ApiErrorToFailureMapperMixIn {
  final PollRepository _repository;

  CancelVoteUseCase(this._repository);

  Future<Either<Failure, TopicDetailEntity?>> call({
    required String topicId,
    required String optionId,
  }) async {
    final deleteVoteRes = await _repository.deleteVoteByOption(optionId);
    if (deleteVoteRes.isLeft) {
      return Left(handleFailure(deleteVoteRes.left));
    }
    // 업데이트 된 topic detail 조회
    return await _repository
        .getTopicDetail(topicId)
        .then((res) => res.fold((l) => const Right(null), (r) => Right(r)));
  }
}
