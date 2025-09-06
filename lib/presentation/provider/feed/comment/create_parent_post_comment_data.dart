part of 'create_parent_post_comment.cubit.dart';

@CopyWith()
class CreateParentPostCommentData {
  final String? latestCreatedCommentId;
  final int commentsCount;

  CreateParentPostCommentData({
    this.latestCreatedCommentId,
    this.commentsCount = 0,
  });
}
