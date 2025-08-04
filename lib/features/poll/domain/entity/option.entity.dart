import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/poll/data/model/option.model.dart';

part 'option.entity.g.dart';

@CopyWith(copyWithNull: true)
class OptionEntity extends BaseEntity {
  final String content;
  final int seq;
  final int voteCount;
  final bool votedByMe;

  OptionEntity({
    required super.id,
    required this.content,
    required this.seq,
    this.voteCount = 0,
    this.votedByMe = false,
    super.createdAt,
    super.updatedAt,
  });

  factory OptionEntity.fromModel(OptionModel model) {
    return OptionEntity(
      id: model.id,
      content: model.content,
      seq: model.seq,
      voteCount: model.voteCount,
      votedByMe: model.votedByMe,
      createdAt: DateTime.tryParse(model.createdAt ?? ''),
      updatedAt: DateTime.tryParse(model.updatedAt ?? ''),
    );
  }
}
