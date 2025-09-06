import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/api_response/api_error.dart';
import 'package:sns/domain/entity/feed/post.entity.dart';
import 'package:sns/domain/entity/feed/post_comment.entity.dart';

abstract interface class FeedRepository {
  Future<Either<ApiError, void>> createPost({
    required String postId,
    required String content,
    bool isPublic = true,
    required List<String> imageUrls,
    required List<int?> widths,
    required List<int?> heights,
  });

  Future<Either<ApiError, Page<PostEntity>>> fetchPosts({
    required String cursor,
    int limit = 20,
  });

  Future<Either<ApiError, void>> deletePost(String postId);

  Future<Either<ApiError, List<String>>> savePostImages({
    required String postId,
    required List<File> images,
  });

  Future<Either<ApiError, int?>> togglePostLike(String postId);

  Future<Either<ApiError, Page<ParentPostCommentEntity>>> fetchParentPostComments({
    required String postId,
    required String cursor,
    int limit = 20,
  });

  Future<Either<ApiError, Page<ChildPostCommentEntity>>> fetchChildPostComments({
    required String postId,
    required String parentId,
    required String cursor,
    int limit = 20,
  });

  Future<Either<ApiError, String>> createParentPostComment({
    required String postId,
    required String content,
  });

  Future<Either<ApiError, String>> createChildPostComment({
    required String postId,
    required String parentId,
    required String content,
  });

  Future<Either<ApiError, void>> deletePostComment(String commentId);
}
