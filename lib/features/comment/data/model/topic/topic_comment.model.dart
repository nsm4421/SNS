import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/features/comment/data/model/abs/abs_comment.model.dart';

class TopicCommentModel extends AbsCommentModel {
  @JsonKey(name: 'topic_id')
  final String topicId;

  TopicCommentModel({
    required super.id,
    required this.topicId,
    required super.content,
    required super.creator,
    super.createdAt,
    super.updatedAt,
  }) : super(refId: topicId);

  factory TopicCommentModel.from(AbsCommentModel base) {
    return TopicCommentModel(
      id: base.id,
      topicId: base.refId,
      content: base.content,
      creator: base.creator,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
    );
  }

  factory TopicCommentModel.fromJson(Map<String, dynamic> json) =>
      TopicCommentModel.from(AbsCommentModel.fromJson(json));
}
