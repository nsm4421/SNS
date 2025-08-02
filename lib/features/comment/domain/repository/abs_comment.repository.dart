import 'package:either_dart/either.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/comment/domain/entity/abs/abs_comment.entity.dart';

abstract interface class AbsCommentRepository<S extends AbsCommentEntity> {
  Future<Either<ApiError, String>> create({
    required String refId,
    required String content,
  });

  Future<Either<ApiError, S>> findById(String commentId);

  Future<Either<ApiError, List<S>>> fetchComments({
    int limit = 20,
    required String refId,
    DateTime? cursor,
  });

  Future<Either<ApiError, void>> delete(String commentId);
}
