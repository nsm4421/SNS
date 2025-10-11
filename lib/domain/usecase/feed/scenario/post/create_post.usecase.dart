part of '../../feed.usecaes.dart';

final class CreatePostUseCase {
  final FeedRepository _repository;

  CreatePostUseCase(this._repository);

  // generate post id
  final _postId = const Uuid().v4();
  List<Uri> _urls = [];

  Future<Either<Failure, FeedPostEntity>> call({
    required String content,
    required List<File> medias,
    void Function(double progress)? onProgress,
    bool isPublic = true,
    String? replyToId,
  }) async {
    // save post
    final createPostRes = await _repository.createPost(
      postId: _postId,
      content: content,
      isPublic: isPublic,
      replyToId: replyToId,
    );
    if (createPostRes.isLeft()) {
      return createPostRes.mapLeft((l) => l.copyWith('create post fails'));
    }

    if (medias.isNotEmpty) {
      // upload files on storage
      final uploadFileRes = await Future.wait(
        medias.map(
          (file) async => await _repository.uploadFile(
            postId: _postId,
            file: file,
            onProgress: onProgress,
          ),
        ),
      );
      if (uploadFileRes.any((e) => e.isLeft())) {
        return createPostRes.mapLeft((l) => l.copyWith('upload media fails'));
      }
      _urls = uploadFileRes.map((e) => e.getRight() as Uri).toList();

      // save storage paths
      final saveStoragePathsRes = await Future.wait(
        medias.indexed.map(
          (e) async => await _repository.insertMedia(
            postId: _postId,
            storagePath: _urls[e.$1].toString(),
            mimeType: e.$2.mimeType,
            sortOrder: e.$1,
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
