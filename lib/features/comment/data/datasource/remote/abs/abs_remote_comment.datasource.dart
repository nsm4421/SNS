part of 'abs_remote_comment.datasource_impl.dart';

abstract interface class AbsRemoteCommentDataSource<T extends AbsCommentModel> {
  Future<String> create({required String refId, required String content});

  Future<T> findById(String commentId);

  Future<Iterable<T>> fetchCommentsByRef({
    int limit = 20,
    required String refId,
    DateTime? cursor,
  });

  Future<void> deleteById(String commentId);
}
