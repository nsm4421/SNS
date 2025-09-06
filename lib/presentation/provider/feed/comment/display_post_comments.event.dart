part of 'display_post_comments.bloc.dart';

class PostCommentCreatedEvent<T extends PostCommentEntity>
    extends SimpleDisplayEvent {
  final T created;

  PostCommentCreatedEvent(this.created);
}
