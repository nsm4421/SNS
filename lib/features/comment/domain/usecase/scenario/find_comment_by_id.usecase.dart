part of '../abs_comment.usecases.dart';

class FindCommentByIdUseCase<T extends AbsCommentEntity>
    with ApiErrorToFailureMapperMixIn {
  final AbsCommentRepository<T> _repository;

  FindCommentByIdUseCase(this._repository);

  Future<Either<Failure, T>> call(String commentId) async {
    return await _repository
        .findById(commentId)
        .then(
          (res) => res.fold((l) {
            switch (l.type) {
              case ApiErrorType.unauthorized:
                return Left(Failure('need to login'));
              case ApiErrorType.notFound:
                return Left(Failure('comment not found'));
              default:
                return Left(handleFailure(l));
            }
          }, (r) => Right(r)),
        );
  }
}
