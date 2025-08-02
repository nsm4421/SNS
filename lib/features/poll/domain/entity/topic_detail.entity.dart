import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/poll/data/model/topic_detail.model.dart';
import 'topic.entity.dart';

part 'topic_detail.entity.g.dart';

@CopyWith(copyWithNull: true)
class TopicDetailEntity extends TopicEntity {
  final List<$OptionItemEntity> options;

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
      createdAt: model.createdAt == null
          ? null
          : DateTime.tryParse(model.createdAt!),
      updatedAt: model.updatedAt == null
          ? null
          : DateTime.tryParse(model.updatedAt!),
      creator: CreatorEntity.from(model.creator),
      options: model.options.map($OptionItemEntity.fromModel).toList(),
    );
  }
}

@CopyWith(copyWithNull: true)
class $OptionItemEntity {
  final String id;
  final String content;
  final int seq;
  final int voteCount;
  final bool voteByMe;

  $OptionItemEntity({
    required this.id,
    required this.content,
    required this.seq,
    this.voteCount = 0,
    this.voteByMe = false,
  });

  factory $OptionItemEntity.fromModel($OptionItemModel model) {
    return $OptionItemEntity(
      id: model.id,
      content: model.content,
      seq: model.seq,
      voteCount: model.voteCount,
      voteByMe: model.voteByMe,
    );
  }
}
