import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:sns/features/poll/data/model/topic.model.dart';

part 'topic.entity.g.dart';

@CopyWith(copyWithNull: true)
class TopicEntity {
  final String id;
  final String title;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String createdBy;

  TopicEntity({
    required this.id,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
    required this.createdBy,
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
      createdBy: model.createdBy,
    );
  }
}
