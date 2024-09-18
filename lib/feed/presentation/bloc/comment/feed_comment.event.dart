part of 'feed_comment.bloc.dart';

@sealed
final class FeedCommentEvent {}

final class InitFeedCommentEvent extends FeedCommentEvent {
  final bool? isMounted;
  final Status? status;
  final String? errorMessage;

  InitFeedCommentEvent({this.isMounted, this.status, this.errorMessage});
}

/// 댓글 조회
final class FetchParentFeedCommentEvent extends FeedCommentEvent {
  final int take;

  FetchParentFeedCommentEvent({this.take = 20});
}

final class FetchChildFeedCommentEvent extends FeedCommentEvent {
  final int take;
  final String parentId;

  FetchChildFeedCommentEvent({this.take = 20, required this.parentId});
}

/// 댓글작성
final class WriteParentFeedCommentEvent extends FeedCommentEvent {
  final String content;

  WriteParentFeedCommentEvent(this.content);
}

final class WriteChildFeedCommentEvent extends FeedCommentEvent {
  final String parentId;
  final String content;

  WriteChildFeedCommentEvent({required this.parentId, required this.content});
}

/// 댓글삭제
final class DeleteParentFeedCommentEvent extends FeedCommentEvent {
  final String commentId;

  DeleteParentFeedCommentEvent(this.commentId);
}

final class DeleteChildFeedCommentEvent extends FeedCommentEvent {
  final String parentId;
  final String commentId;

  DeleteChildFeedCommentEvent(
      {required this.parentId, required this.commentId});
}
