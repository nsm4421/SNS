import 'package:either_dart/src/either.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/comment/data/datasource/remote/abs/abs_remote_comment.datasource_impl.dart';
import 'package:sns/features/comment/data/model/abs/abs_comment.model.dart';
import 'package:sns/features/comment/domain/entity/abs/abs_comment.entity.dart';
import 'package:sns/features/comment/domain/repository/abs_comment.repository.dart';

class AbsCommentRepositoryImpl<
  T extends AbsCommentModel,
  S extends AbsCommentEntity
>
    with AppLogger, RepositoryResponseWrapperMixIn
    implements AbsCommentRepository<S> {
  final AbsRemoteCommentDataSource<T> _remoteDataSource;
  final S Function(T) _convert;

  AbsCommentRepositoryImpl({
    required AbsRemoteCommentDataSource<T> remoteDataSource,
    required S Function(T) convert,
  }) : _remoteDataSource = remoteDataSource,
       _convert = convert;

  @override
  Future<Either<ApiError, String>> create({
    required String refId,
    required String content,
  }) async => await guardApi<String>(() async {
    return await _remoteDataSource.create(refId: refId, content: content);
  }, logger: logger);

  @override
  Future<Either<ApiError, void>> delete(String commentId) async =>
      await guardApi<void>(() async {
        await _remoteDataSource.deleteById(commentId);
      }, logger: logger);

  @override
  Future<Either<ApiError, List<S>>> fetchComments({
    int limit = 20,
    required String refId,
    DateTime? cursor,
  }) async => await guardApi<List<S>>(() async {
    return await _remoteDataSource
        .fetchCommentsByRef(refId: refId, limit: limit, cursor: cursor)
        .then((res) => res.map(_convert).toList());
  });

  @override
  Future<Either<ApiError, S>> findById(String commentId) async =>
      await guardApi<S>(() async {
        return await _remoteDataSource.findById(commentId).then(_convert);
      });
}
