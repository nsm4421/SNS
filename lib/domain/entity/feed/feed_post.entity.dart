import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:karma/domain/entity/entity.export.dart';

import '../auth/user.entity.dart';
import 'feed_media.entity.dart';

part 'feed_post.entity.g.dart';

@CopyWith(copyWithNull: true)
class FeedPostEntity {
  final String postId;
  final String content;
  final bool isPublic;
  final String createdBy;
  final String? replyToId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int likeCount;
  final int commentCount;

  FeedPostEntity({
    required this.postId,
    this.content = '',
    this.isPublic = true,
    required this.createdBy,
    this.replyToId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.likeCount = 0,
    this.commentCount = 0,
  });
}

@CopyWith(copyWithNull: true)
class FeedPostEntityWithAuthor extends FeedPostEntity {
  final UserEntity author;
  final List<FeedMediaEntity> medias;
  final PostCommentEntityWithAuthor? latestComment;
  final bool likedByMe;

  FeedPostEntityWithAuthor({
    required super.postId,
    super.content = '',
    super.isPublic = true,
    required this.author,
    this.medias = const[],
    super.replyToId,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
    super.likeCount,
    super.commentCount,
    this.latestComment,
    this.likedByMe = false
  }) : super(createdBy: author.id);
}
