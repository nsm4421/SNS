part of '../abs_comment.usecases.dart';

class CreateCommentUseCase with ApiErrorToFailureMapperMixIn {
  final AbsCommentRepository _repository;

  CreateCommentUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required String refId,
    required String content,
  }) async {
    return await _repository
        .create(refId: refId, content: content)
        .then(
          (res) => res.fold((l) => Left(handleFailure(l)), (r) => Right(r)),
        );
  }
}
