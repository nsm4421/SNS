part of '../../feed.usecaes.dart';

final class GetPostUseCase {
  final FeedRepository _repository;

  GetPostUseCase(this._repository);

  Future<Either<Failure, FeedPostEntityWithAuthor>> call(String postId) async {
    return await _repository.getPost(postId);
  }
}
