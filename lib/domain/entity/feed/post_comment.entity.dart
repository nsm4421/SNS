import 'package:copy_with_extension/copy_with_extension.dart';
import '../auth/user.entity.dart';

part 'post_comment.entity.g.dart';

@CopyWith(copyWithNull: true)
class PostCommentEntity {
  final String id;
  final String postId;
  final String content;
  final String? parentId;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  PostCommentEntity({
    required this.id,
    required this.postId,
    this.content = '',
    this.parentId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}

@CopyWith(copyWithNull: true)
class PostCommentEntityWithAuthor extends PostCommentEntity {
  final UserEntity author;

  PostCommentEntityWithAuthor({
    required super.id,
    required this.author,
    required super.postId,
    super.content,
    super.parentId,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
  }) : super(createdBy: author.id);
}
