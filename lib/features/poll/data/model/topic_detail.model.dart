import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/core/data/model/creator.model.dart';
import 'package:sns/core/data/model/base.model.dart';

part 'topic_detail.model.g.dart';

part 'topic_detail.model.freezed.dart';

@freezed
@JsonSerializable()
class TopicDetailModel with _$TopicDetailModel implements BaseModelWithUser {
  @JsonKey(name: 'topic_id')
  final String id;
  @JsonKey(name: 'creator')
  final CreatorModel creator;
  final String title;
  final String description;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final Iterable<$OptionItemModel> options;

  TopicDetailModel({
    required this.id,
    required this.creator,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
    required this.options,
  });

  factory TopicDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TopicDetailModelFromJson(json);
}

@freezed
@JsonSerializable()
class $OptionItemModel with _$$OptionItemModel {
  final String id;
  final String content;
  final int seq;
  @JsonKey(name: 'vote_count')
  final int voteCount;
  @JsonKey(name: 'vote_by_me')
  final bool voteByMe;

  $OptionItemModel({
    required this.id,
    required this.content,
    required this.seq,
    this.voteCount = 0,
    this.voteByMe = false,
  });

  factory $OptionItemModel.fromJson(Map<String, dynamic> json) =>
      _$$OptionItemModelFromJson(json);
}
