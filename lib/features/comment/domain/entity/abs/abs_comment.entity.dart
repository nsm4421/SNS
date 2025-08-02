import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/comment/data/model/abs/abs_comment.model.dart';

part 'abs_comment.entity.g.dart';

@CopyWith(copyWithNull: true)
class AbsCommentEntity extends BaseEntityWithUser {
  final String content;
  final String refId;

  AbsCommentEntity({
    required super.id,
    required this.content,
    required this.refId,
    super.createdAt,
    super.updatedAt,
    required super.creator,
  });

  factory AbsCommentEntity.from(AbsCommentModel model) {
    return AbsCommentEntity(
      id: model.id,
      content: model.content,
      refId: model.refId,
      createdAt: DateTime.tryParse(model.createdAt ?? ''),
      updatedAt: DateTime.tryParse(model.updatedAt ?? ''),
      creator: CreatorEntity.from(model.creator),
    );
  }
}
