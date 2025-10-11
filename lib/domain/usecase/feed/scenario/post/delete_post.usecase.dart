part of '../../feed.usecaes.dart';

final class DeletePostUseCase {
  final FeedRepository _repository;

  DeletePostUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String postId) async {
    return await _repository
        .deletePost(postId)
        .then((res) => res.mapLeft((l) => l.copyWith('delete post fails')));
  }
}
