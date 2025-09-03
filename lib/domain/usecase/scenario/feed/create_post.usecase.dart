import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/core/extension/logger.extension.dart';
import 'package:sns/core/media/image_util_mixin.dart';
import 'package:sns/domain/repository/feed.repository.dart';
import 'package:uuid/uuid.dart';

class CreatePostUseCase with ImageUtilMixIn {
  final FeedRepository _repository;
  final Logger? logger;

  CreatePostUseCase(this._repository, {this.logger});

  Future<Either<Failure, String>> call({
    required String content,
    required List<XFile> images,
    bool isPublic = true,
  }) async {
    final postId = const Uuid().v4();
    List<String> imageUrls = [];
    List<(int, int)> sizes = [];

    // save images in storage
    if (images.isNotEmpty) {
      final uploadImageRes = await _repository.savePostImages(
        postId: postId,
        images: images.map((e) => File(e.path)).toList(),
      );
      if (uploadImageRes.isLeft) {
        return Left(Failure('이미지 업로드중 오류가 발생했습니다'));
      }
      imageUrls = uploadImageRes.right;
      sizes = await Future.wait(
        images.map(((e) async => await getXFileSize(e))),
      );
    }

    // save feed data in database
    final createPostRes = await _repository.createPost(
      postId: postId,
      content: content,
      isPublic: isPublic,
      imageUrls: imageUrls,
      widths: sizes.map((e) => e.$1).toList(),
      heights: sizes.map((e) => e.$2).toList(),
    );
    if (createPostRes.isLeft) {
      logger?.logApiError(createPostRes.left);
      return Left(Failure('포스팅 작성 중 오류가 발생했습니다'));
    }

    return Right(postId);
  }
}
