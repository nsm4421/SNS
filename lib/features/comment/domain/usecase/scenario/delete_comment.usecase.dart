part of '../abs_comment.usecases.dart';

class DeleteCommentUseCase with ApiErrorToFailureMapperMixIn {
  final AbsCommentRepository _repository;

  DeleteCommentUseCase(this._repository);

  Future<Either<Failure, void>> call(String commentId) async {
    return await _repository
        .delete(commentId)
        .then(
          (res) => res.fold((l) {
            switch (l.type) {
              case ApiErrorType.unauthorized:
                return Left(Failure('need to login'));
              case ApiErrorType.notFound:
                return Left(Failure('comment not exist'));
              default:
                return Left(handleFailure(l));
            }
          }, (_) => const Right(null)),
        );
  }
}
