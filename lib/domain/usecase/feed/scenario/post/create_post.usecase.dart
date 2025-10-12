part of '../../feed.usecaes.dart';

final class UploadPostMediaUseCase {
  final FeedRepository _repository;

  UploadPostMediaUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required String clientPostId,
    required File file,
    void Function(double progress)? onProgress,
  }) async {
    return await _repository
        .uploadFile(postId: clientPostId, file: file, onProgress: onProgress)
        .then((res) => res.mapLeft((l) => l.copyWith('upload media fails')));
  }
}

final class SavePostOnDbUseCase {
  final FeedRepository _repository;

  SavePostOnDbUseCase(this._repository);

  Future<Either<Failure, FeedPostEntity>> call({
    required String clientPostId,
    required String content,
    required List<String> storagePaths,
    required List<String> mimeTypes,
    required List<int> widths,
    required List<int> heights,
    bool isPublic = true,
    String? replyToId,
  }) async {
    // save post
    final createPostRes = await _repository.createPost(
      postId: clientPostId,
      content: content,
      isPublic: isPublic,
      replyToId: replyToId,
    );
    if (createPostRes.isLeft()) {
      return createPostRes.mapLeft((l) => l.copyWith('create post fails'));
    }

    if (storagePaths.isNotEmpty) {
      // save storage paths
      final saveStoragePathsRes = await Future.wait(
        storagePaths.indexed.map(
          (e) async => await _repository.insertMedia(
            postId: clientPostId,
            storagePath: e.$2,
            mimeType: mimeTypes[e.$1],
            sortOrder: e.$1,
            width: widths[e.$1],
            height: heights[e.$1],
          ),
        ),
      );
      if (saveStoragePathsRes.any((e) => e.isLeft())) {
        return createPostRes.mapLeft((l) => l.copyWith('upload media fails'));
      }
    }

    return createPostRes;
  }
}
