import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/core/media/image_util_mixin.dart';
import 'package:sns/domain/entity/feed/feed.entity.dart';
import 'package:sns/domain/repository/feed.repository.dart';

class FetchFeedsUseCase with ImageUtilMixIn {
  final FeedRepository _feedRepository;
  final Logger? logger;

  FetchFeedsUseCase(this._feedRepository, {this.logger});

  Future<Either<Failure, Page<FeedEntity>>> call({
    required String cursor,
    int limit = 20,
  }) async {
    return await _feedRepository
        .fetchPosts(cursor: cursor, limit: limit)
        .then(
          (res) => res.fold((l) {
            return Left(Failure('피드 조회 중 오류가 발생했습니다'));
          }, (r) => Right(r)),
        );
  }
}
