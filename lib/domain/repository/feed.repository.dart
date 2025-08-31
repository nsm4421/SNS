import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/api_response/api_error.dart';
import 'package:sns/domain/entity/feed/feed_post.entity.dart';

abstract interface class FeedRepository {
  Future<Either<ApiError, void>> createFeed({
    required String feedId,
    required String content,
    bool isPublic = true,
    required List<String> imageUrls,
    required List<int?> widths,
    required List<int?> heights,
  });

  Future<Either<ApiError, Page<FeedPostEntity>>> fetchPosts({
    String? cursor,
    int limit = 20,
  });

  Future<Either<ApiError, void>> deletePost(String postId);

  Future<Either<ApiError, List<String>>> saveFeedImages({
    required String feedId,
    required List<File> images,
  });
}
