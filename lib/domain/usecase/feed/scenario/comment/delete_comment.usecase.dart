part of '../../feed.usecaes.dart';

final class DeleteCommentUseCase {
  final FeedRepository _repository;

  DeleteCommentUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String commentId) async {
    return await _repository
        .deleteComment(commentId)
        .then((res) => res.mapLeft((l) => l.copyWith('delete comment fails')));
  }
}
