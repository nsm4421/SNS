import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/poll/data/model/topic_detail.model.dart';
import 'option.entity.dart';
import 'topic.entity.dart';

part 'topic_detail.entity.g.dart';

@CopyWith(copyWithNull: true)
class TopicDetailEntity extends TopicEntity {
  final List<OptionEntity> options;

  TopicDetailEntity({
    required super.id,
    required super.title,
    required super.description,
    required super.creator,
    super.createdAt,
    super.updatedAt,
    required this.options,
  });

  factory TopicDetailEntity.fromModel(TopicDetailModel model) {
    return TopicDetailEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      createdAt: DateTime.tryParse(model.createdAt ?? ''),
      updatedAt: DateTime.tryParse(model.updatedAt ?? ''),
      creator: CreatorEntity.from(model.creator),
      options: model.options.map(OptionEntity.fromModel).toList(),
    );
  }

  OptionEntity? get selected =>
      options.where((item) => item.votedByMe).firstOrNull;
}
