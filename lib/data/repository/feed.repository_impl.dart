import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:fpdart/src/either.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/exception/failure.dart';
import 'package:karma/core/extension/file.extension.dart';
import 'package:karma/core/vo/pageable.vo.dart';
import 'package:karma/data/datasource/datasource.export.dart';
import 'package:karma/data/datasource/rpc/feed/feed_rpc.datasource.dart';
import 'package:karma/data/model/model.export.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/repository/repository.export.dart';

@LazySingleton(as: FeedRepository)
class FeedRepositoryImpl implements FeedRepository {
  final FeedTablesDataSource _feedTablesDataSource;
  final FeedBucketDataSource _feedBucketDataSource;
  final FeedRpcDataSource _feedRpcDataSource;

  FeedRepositoryImpl({
    required FeedTablesDataSource feedTableDataSource,
    required FeedBucketDataSource feedBucketDataSource,
    required FeedRpcDataSource feedRpcDataSource,
  }) : _feedTablesDataSource = feedTableDataSource,
       _feedBucketDataSource = feedBucketDataSource,
       _feedRpcDataSource = feedRpcDataSource;

  /// --- Post ---
  @override
  Future<Either<Failure, FeedPostEntity>> createPost({
    required String postId,
    required String content,
    bool isPublic = true,
    String? replyToId,
  }) async {
    try {
      return await _feedTablesDataSource
          .createPost(
            CreatePostRequestDto(
              clientPostId: postId,
              content: content,
              visibilityText: isPublic ? 'public' : 'private',
              replyToId: replyToId,
            ),
          )
          .then((res) => res.toEntity())
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, FeedPostEntity>> getPost(String postId) async {
    try {
      return await _feedTablesDataSource
          .getPostById(postId)
          .then((res) => res.toEntity())
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Pageable<FeedPostEntityWithAuthor>>> fetchFeeds({
    required String cursor,
    int limit = 30,
    bool isMediaUrlIsPublic = true,
  }) async {
    try {
      return await _feedTablesDataSource
          .fetchFeedList(cursor: cursor, limit: limit)
          .then(
            (res) => res.convert((model) {
              final entity = model.toEntity();
              final medias = entity.medias
                  .map(
                    (e) => e.copyWith(publicUrl: _getPublicUrl(e.storagePath)),
                  )
                  .toList();
              return entity.copyWith(medias: medias);
            }),
          )
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePost(String postId) async {
    try {
      return await _feedTablesDataSource
          .deletePost(postId, isSoft: true)
          .then((_) => const Right(unit));
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  /// --- likes ---
  @override
  Future<Either<Failure, (bool likedByMe, int likeCount)>> toggleLike(
    String postId,
  ) async {
    try {
      return await _feedRpcDataSource.toggleLike(postId).then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, bool>> getIsLike(String postId) async {
    try {
      return await _feedTablesDataSource
          .findPostLike(postId)
          .then((e) => e != null)
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  /// --- Comment ---
  @override
  Future<Either<Failure, PostCommentEntity>> addComment({
    required String commentId,
    required String postId,
    String? parentId,
    required String content,
  }) async {
    try {
      return await _feedTablesDataSource
          .addComment(
            CreateCommentRequestDto(
              clientCommentId: commentId,
              postId: postId,
              parentId: parentId,
              content: content,
            ),
          )
          .then((e) => e.toEntity())
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Pageable<PostCommentEntityWithAuthor>>> fetchComments({
    required String postId,
    required String cursor,
    int limit = 30,
  }) async {
    try {
      return await _feedTablesDataSource
          .fetchComments(cursor: cursor, limit: limit, postId: postId)
          .then((res) => res.convert((e) => e.toEntity()))
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteComment(String commentId) async {
    try {
      return await _feedTablesDataSource
          .deleteComment(commentId, isSoft: true)
          .then((_) => const Right(unit));
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  /// --- Media ---
  @override
  Future<Either<Failure, FeedMediaEntity>> insertMedia({
    required String postId,
    required String storagePath,
    String? mimeType,
    int? width,
    int? height,
    required int sortOrder,
  }) async {
    try {
      return await _feedTablesDataSource
          .insertMedia(
            InsertMediaRequestDto(
              postId: postId,
              storagePath: storagePath,
              mimeType: mimeType,
              width: width,
              height: height,
              sortOrder: sortOrder,
            ),
          )
          .then((res) => res.toEntity())
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, List<FeedMediaEntity>>> getMedias(
    String postId,
  ) async {
    try {
      return await _feedTablesDataSource
          .getMedias(postId)
          .then(
            (res) => res
                .map((e) => e.toEntity())
                .map((e) => e.copyWith(publicUrl: _getPublicUrl(e.storagePath)))
                .toList(),
          )
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMedia(String mediaId) async {
    try {
      return await _feedTablesDataSource
          .deleteMedia(mediaId)
          .then((_) => const Right(unit));
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> reorderMedia({
    required String postId,
    required Map<String, int> orders,
  }) async {
    try {
      return await _feedTablesDataSource
          .reorderMedias(ReorderMediaRequestDto(postId: postId, orders: orders))
          .then((_) => const Right(unit));
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  /// --- storage ---
  @override
  Future<Either<Failure, Unit>> deleteFile(String storagePath) async {
    try {
      return await _feedBucketDataSource
          .delete(storagePath)
          .then((_) => const Right(unit));
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, Uri>> uploadFile({
    required String postId,
    required File file,
    void Function(double progress)? onProgress,
    bool upsert = false,
  }) async {
    try {
      return await _feedBucketDataSource
          .uploadBytes(
            postId: postId,
            filename: file.filename,
            mimeType: file.mimeType,
            bytes: await file.readAsBytes(),
            onProgress: onProgress,
            upsert: upsert,
          )
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  String _getPublicUrl(
    String storagePath, {
    int? width,
    int? height,
    int quality = 80,
  }) {
    return _feedBucketDataSource
        .getPublicUrl(
          storagePath,
          width: width,
          height: height,
          quality: quality,
        )
        .toString();
  }
}
