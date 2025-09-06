import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:sns/domain/entity/base/creator.entity.dart';

part 'post_comment.entity.g.dart';

@CopyWith(copyWithNull: true)
class PostCommentEntity extends BaseEntityWithCreator {
  PostCommentEntity({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required super.creator,
    required this.postId,
    this.content = '',
  });

  final String postId;
  final String content;
}

@CopyWith(copyWithNull: true)
class ChildPostCommentEntity extends PostCommentEntity {
  final String parentId;

  ChildPostCommentEntity({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required super.creator,
    required super.postId,
    super.content,
    required this.parentId,
  });
}

@CopyWith(copyWithNull: true)
class ParentPostCommentEntity extends PostCommentEntity {
  final List<ChildPostCommentEntity> children;

  ParentPostCommentEntity({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required super.creator,
    required super.postId,
    super.content,
    required this.children,
  });
}
