part of 'remote_comment.datasource_impl.dart';

abstract interface class RemoteCommentDataSource {
  Future<void> create(Map<String, dynamic> json);
}