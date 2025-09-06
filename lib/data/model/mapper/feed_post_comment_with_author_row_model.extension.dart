import 'package:sns/domain/entity/base/creator.entity.dart';
import 'package:sns/domain/entity/feed/post_comment.entity.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';

extension FeedPostCommentsWithAuthorRowExtension on FeedPostCommentsWithAuthorRow {
  ParentPostCommentEntity toParentEntity({
    List<ChildPostCommentEntity>? children,
  }) {
    return ParentPostCommentEntity(
      id: id!,
      creator: CreatorEntity(id: createdBy!, username: username!),
      content: content ?? '',
      postId: postId!,
      createdAt: createdAt,
      children: children ?? [],
    );
  }

  ChildPostCommentEntity toChildEntity() {
    return ChildPostCommentEntity(
      id: id!,
      postId: postId!,
      parentId: parentId!,
      creator: CreatorEntity(id: createdBy!, username: username!),
      content: content ?? '',
      createdAt: createdAt,
    );
  }
}
