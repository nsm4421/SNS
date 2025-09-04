import 'package:sns/domain/entity/base/creator.entity.dart';
import 'package:sns/domain/entity/feed/post_comment.entity.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';

extension FeedPostCommentsRowExtension on FeedPostCommentsRow {
  // username 컬럼은 빈문자열로 처리함
  // optimistic update시에 username 컬럼 업데이트
  ParentPostCommentEntity toParentEntity({
    List<ChildPostCommentEntity>? children,
  }) {
    return ParentPostCommentEntity(
      id: id!,
      creator: CreatorEntity(id: createdBy, username: ''),
      content: content ?? '',
      createdAt: createdAt,
      children: children ?? [],
    );
  }

  ChildPostCommentEntity toChildEntity() {
    return ChildPostCommentEntity(
      id: id!,
      parentId: parentId!,
      creator: CreatorEntity(id: createdBy, username: ''),
      content: content ?? '',
      createdAt: createdAt,
    );
  }
}
