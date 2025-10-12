import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/domain/entity/entity.export.dart';

abstract interface class FeedRepository {
  /// --- post ---
  Future<Either<Failure, FeedPostEntity>> createPost({
    required String postId,
    required String content,
    bool isPublic = true,
    String? replyToId,
  });

  Future<Either<Failure, FeedPostEntity>> getPost(String postId);

  Future<Either<Failure, Pageable<FeedPostEntityWithAuthor>>> fetchFeeds({
    required String cursor,
    int limit = 30,
    bool isMediaUrlIsPublic = true,
  });

  Future<Either<Failure, Unit>> deletePost(String postId);

  /// --- likes ---
  Future<Either<Failure, (bool likedByMe, int likeCount)>> toggleLike(
    String postId,
  );

  Future<Either<Failure, bool>> getIsLike(String postId);

  /// --- comment ---
  Future<Either<Failure, PostCommentEntity>> addComment({
    required String commentId,
    required String postId,
    String? parentId,
    required String content,
  });

  Future<Either<Failure, Pageable<PostCommentEntityWithAuthor>>> fetchComments({
    required String postId,
    required String cursor,
    int limit = 30,
  });

  Future<Either<Failure, Unit>> deleteComment(String commentId);

  /// --- media ---
  Future<Either<Failure, FeedMediaEntity>> insertMedia({
    required String postId,
    required String storagePath,
    String? mimeType,
    int? width,
    int? height,
    required int sortOrder,
  });

  Future<Either<Failure, Unit>> deleteMedia(String mediaId);

  Future<Either<Failure, Unit>> reorderMedia({
    required String postId,
    required Map<String, int> orders,
  });

  /// --- Bucket ---
  Future<Either<Failure, String>> uploadFile({
    required String postId,
    required File file,
    void Function(double progress)? onProgress,
    bool upsert = false,
  });

  Future<Either<Failure, Unit>> deleteFile(String storagePath);
}
