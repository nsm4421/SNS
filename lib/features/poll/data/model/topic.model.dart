import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/core/data/model/creator.model.dart';
import 'package:sns/core/data/model/base.model.dart';

part 'topic.model.g.dart';

part 'topic.model.freezed.dart';

@freezed
@JsonSerializable()
class TopicModel with _$TopicModel implements BaseModelWithUser {
  final String id;
  final String title;
  final String description;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'creator')
  final CreatorModel creator;

  TopicModel({
    required this.id,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
    required this.creator,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) =>
      _$TopicModelFromJson(json);
}
