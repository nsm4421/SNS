part of 'display_posts.bloc.dart';

class UpdatePostCommentsCountEvent extends SimpleDisplayEvent {
  final String postId;
  final int delta;

  UpdatePostCommentsCountEvent({required this.postId, required this.delta});
}
