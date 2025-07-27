import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_topic_detail_request.model.g.dart';

part 'get_topic_detail_request.model.freezed.dart';

@freezed
@JsonSerializable()
class GetTopicDetailRequestModel with _$GetTopicDetailRequestModel {
  @JsonKey(name: 'p_topic_id')
  final String topicId;

  GetTopicDetailRequestModel({required this.topicId});

  factory GetTopicDetailRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GetTopicDetailRequestModelFromJson(json);

  Map<String, Object?> toJson() => _$GetTopicDetailRequestModelToJson(this);
}
