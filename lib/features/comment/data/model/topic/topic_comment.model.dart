import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/comment/data/model/abs/abs_comment.model.dart';

part 'topic_comment.model.freezed.dart';

part 'topic_comment.model.g.dart';

@freezed
@JsonSerializable()
class TopicCommentModel with _$TopicCommentModel implements AbsCommentModel {
  final String id;
  @JsonKey(name: 'topic_id')
  final String refId;
  final String content;
  final String? createdAt;
  final String? updatedAt;
  final CreatorModel creator;

  TopicCommentModel({
    required this.id,
    required this.refId,
    required this.content,
    required this.creator,
    this.createdAt,
    this.updatedAt,
  });

  factory TopicCommentModel.fromJson(Map<String, dynamic> json) =>
      _$TopicCommentModelFromJson(json);
}
