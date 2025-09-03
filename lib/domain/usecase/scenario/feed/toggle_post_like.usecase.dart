import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/repository/feed.repository.dart';

class TogglePostLikeUseCase {
  final FeedRepository _repository;
  final Logger? logger;

  TogglePostLikeUseCase(this._repository, {this.logger});

  Future<Either<Failure, int?>> call(String postId) async {
    return await _repository
        .togglePostLike(postId)
        .mapLeft((l) => Failure('좋아요 요청 실패'));
  }
}
