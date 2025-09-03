import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/api_response/api_error.dart';
import 'package:sns/core/logger/app_logger.dart';
import 'package:sns/data/datasource/auth/auth.datasource_impl.dart';
import 'package:sns/data/datasource/feed/feed_storage.dastasource_impl.dart';
import 'package:sns/data/model/mapper/feed_posts_with_counts_row_model.extension.dart';
import 'package:sns/domain/entity/feed/feed.entity.dart';
import 'package:sns/domain/repository/feed.repository.dart';
import 'package:supabase_datasource/datasources/database/features/feed/feed.datasource_impl.dart';
import 'package:supabase_datasource/datasources/model/feed/image/insert_feed_post_image_request.model.dart';
import 'package:supabase_datasource/datasources/model/feed/post/create_feed_post_request.model.dart';

@LazySingleton(as: FeedRepository)
class FeedRepositoryImpl with AppLogger implements FeedRepository {
  final AuthDataSource _authDataSource;
  final FeedDatabaseDataSource _feedDatabaseDataSource;
  final FeedStorageDataSource _feedStorageDataSource;

  FeedRepositoryImpl({
    required AuthDataSource authDataSource,
    required FeedDatabaseDataSource feedDatabaseDataSource,
    required FeedStorageDataSource feedStorageDataSource,
  }) : _authDataSource = authDataSource,
       _feedDatabaseDataSource = feedDatabaseDataSource,
       _feedStorageDataSource = feedStorageDataSource;

  @override
  Future<Either<ApiError, void>> createPost({
    required String postId,
    required String content,
    bool isPublic = true,
    required List<String> imageUrls,
    required List<int?> widths,
    required List<int?> heights,
  }) async {
    try {
      await _feedDatabaseDataSource.post.createPost(
        CreateFeedPostRequestModel(
          postId: postId,
          content: content,
          isPublic: isPublic,
        ),
      );

      if (imageUrls.isNotEmpty) {
        await _feedDatabaseDataSource.image.insertImages(
          imageUrls.indexed.map(
            (e) => InsertFeedPostImageRequestModel(
              postId: postId,
              objectPath: e.$2,
              width: widths[e.$1],
              height: heights[e.$1],
              orderIndex: e.$1,
            ),
          ),
        );
      }

      return const Right(null);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, void>> deletePost(String postId) async {
    try {
      return await _feedDatabaseDataSource.post
          .deletePostById(postId)
          .then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, Page<FeedEntity>>> fetchPosts({
    required String cursor,
    int limit = 20,
  }) async {
    try {
      return await _feedDatabaseDataSource.post
          .fetchPosts(cursor: cursor, limit: limit)
          .then((res) => res.convert((e) => e.toEntity()))
          .then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, List<String>>> savePostImages({
    required String postId,
    required List<File> images,
  }) async {
    assert(images.isNotEmpty);
    try {
      return await _feedStorageDataSource
          .uploadFeedImages(
            currentUid: _authDataSource.currentUid!,
            postId: postId,
            images: images,
          )
          .then((res) => res.toList())
          .then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, int?>> togglePostLike(String postId) async {
    try {
      return await _feedDatabaseDataSource.like
          .toggleLike(postId)
          .then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }
}
