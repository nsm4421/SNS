part of '../poll.usecases.dart';

class CastVoteUseCase with ApiErrorToFailureMapperMixIn {
  final PollRepository _repository;

  CastVoteUseCase(this._repository);

  Future<Either<Failure, TopicDetailEntity?>> call({
    required String topicId,
    required String optionId,
  }) async {
    // 투표 진행
    final voteRes = await _repository.upsertVote(optionId);
    if (voteRes.isLeft) {
      return Left(handleFailure(voteRes.left));
    }
    // 업데이트 된 topic detail 조회
    return await _repository
        .getTopicDetail(topicId)
        .then((res) => res.fold((l) => const Right(null), (r) => Right(r)));
  }
}
