part of '../abs_comment.usecases.dart';

class FetchCommentsUseCase<T extends AbsCommentEntity>
    with ApiErrorToFailureMapperMixIn {
  final AbsCommentRepository<T> _repository;

  FetchCommentsUseCase(this._repository);

  Future<Either<Failure, List<T>>> call({
    int limit = 20,
    required String refId,
    DateTime? cursor,
  }) async {
    return await _repository
        .fetchComments(refId: refId, limit: limit, cursor: cursor)
        .then(
          (res) => res.fold((l) => Left(handleFailure(l)), (r) => Right(r)),
        );
  }
}
