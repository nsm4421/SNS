part of '../../feed.usecaes.dart';

final class ToggleLikeUseCase {
  final FeedRepository _repository;

  ToggleLikeUseCase(this._repository);

  Future<Either<Failure, (bool likedByMe, int likeCount)>> call(
    String postId,
  ) async {
    return await _repository
        .toggleLike(postId)
        .then((res) => res.mapLeft((l) => l.copyWith('toggle like fails')));
  }
}
