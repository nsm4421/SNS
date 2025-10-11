part of '../../feed.usecaes.dart';

final class CreateCommentUseCase {
  final FeedRepository _repository;

  CreateCommentUseCase(this._repository);

  // generate id
  final _commentId = const Uuid().v4();

  Future<Either<Failure, PostCommentEntity>> call({
    required String postId,
    String? parentId,
    required String content,
  }) async {
    return await _repository
        .addComment(commentId: _commentId, postId: postId, content: content)
        .then((res) => res.mapLeft((l) => l.copyWith('create comment fails')));
  }
}
