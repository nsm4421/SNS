import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/comment/data/model/topic/topic_comment.model.dart';
import 'package:sns/features/comment/domain/entity/abs/abs_comment.entity.dart';

part 'topic_comment.entity.g.dart';

@CopyWith(copyWithNull: true)
class TopicCommentEntity extends AbsCommentEntity {
  final String topicId;

  TopicCommentEntity({
    required super.id,
    required this.topicId,
    required super.content,
    required super.creator,
    super.createdAt,
    super.updatedAt,
  }) : super(refId: topicId);

  factory TopicCommentEntity.from(TopicCommentModel model) {
    return TopicCommentEntity(
      id: model.id,
      topicId: model.topicId,
      content: model.content,
      creator: CreatorEntity.from(model.creator),
      createdAt: DateTime.tryParse(model.createdAt ?? ''),
      updatedAt: DateTime.tryParse(model.updatedAt ?? ''),
    );
  }
}
