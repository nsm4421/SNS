import 'package:karma/data/datasource/datasource.export.dart';
import 'package:karma/domain/entity/entity.export.dart';

extension FeedEntityMapper on FeedPostsRow {
  FeedPostEntity toEntity() {
    return FeedPostEntity(
      postId: id,
      content: content,
      isPublic: visibility == FeedVisibility.public,
      replyToId: replyToId,
      createdBy: authorId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      likeCount: likeCount,
      commentCount: commentCount,
    );
  }
}

extension FeedEntityWithAuthorMapper on VFeedListRow {
  FeedPostEntityWithAuthor toEntity() {
    return FeedPostEntityWithAuthor(
      postId: id!,
      content: content ?? '',
      isPublic: visibility == FeedVisibility.public,
      replyToId: replyToId,
      author: UserEntity(
        id: authorId!,
        username: authorUsername!,
        avatarUrl: authorAvatarUrl,
      ),
      createdAt: createdAt!,
      updatedAt: updatedAt!,
      deletedAt: deletedAt,
      likeCount: likeCount ?? 0,
      commentCount: commentCount ?? 0,
      latestComment: latestCommentId == null
          ? null
          : PostCommentEntityWithAuthor(
              id: latestCommentId!,
              postId: id!,
              content: latestCommentContent!,
              author: UserEntity(
                id: latestCommentAuthorId!,
                username: latestCommentAuthorUsername,
                avatarUrl: latestCommentAuthorAvatarUrl,
              ),
              createdAt: latestCommentCreatedAt!,
              updatedAt: latestCommentCreatedAt!,
            ),
      medias: mediaPaths
          .map((e) => FeedMediaEntity(postId: id!, storagePath: e))
          .toList(),
      likedByMe: likedByMe ?? false
    );
  }
}

extension FeedCommentMapper on FeedCommentsRow {
  PostCommentEntity toEntity() {
    return PostCommentEntity(
      id: id,
      postId: postId,
      parentId: parentId,
      content: content,
      createdBy: authorId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}

extension FeedCommentWithAuthorMapper on VFeedCommentListRow {
  PostCommentEntityWithAuthor toEntity() {
    return PostCommentEntityWithAuthor(
      id: id!,
      postId: postId!,
      parentId: parentId,
      content: content ?? '',
      author: UserEntity(
        id: authorId!,
        username: authorUsername,
        avatarUrl: authorAvatarUrl,
      ),
      createdAt: createdAt!,
      updatedAt: updatedAt!,
      deletedAt: null,
    );
  }
}

extension FeedMediaMapper on FeedMediaRow {
  FeedMediaEntity toEntity([String? publicUrl]) {
    return FeedMediaEntity(
      postId: postId,
      storagePath: storagePath,
      publicUrl: publicUrl,
      id: id,
      mimeType: mimeType,
      width: width,
      height: height,
      sortOrder: sortOrder,
      createdAt: createdAt,
    );
  }
}
