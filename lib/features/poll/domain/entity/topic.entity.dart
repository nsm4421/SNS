import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/poll/data/model/topic.model.dart';

part 'topic.entity.g.dart';

@CopyWith(copyWithNull: true)
class TopicEntity extends BaseEntityWithUser {
  final String title;
  final String description;

  TopicEntity({
    required super.id,
    required this.title,
    required this.description,
    super.createdAt,
    super.updatedAt,
    required super.creator,
  });

  factory TopicEntity.fromModel(TopicModel model) {
    return TopicEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      createdAt: model.createdAt == null
          ? null
          : DateTime.tryParse(model.createdAt!),
      updatedAt: model.updatedAt == null
          ? null
          : DateTime.tryParse(model.updatedAt!),
      creator: CreatorEntity.from(model.creator),
    );
  }
}
