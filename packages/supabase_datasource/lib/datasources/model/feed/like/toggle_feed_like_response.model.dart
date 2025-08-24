import 'package:freezed_annotation/freezed_annotation.dart';

part 'toggle_feed_like_response.model.freezed.dart';

part 'toggle_feed_like_response.model.g.dart';

@freezed
@JsonSerializable()
class ToggleFeedLikeResponseModel with _$ToggleFeedLikeResponseModel {
  final bool liked;
  @JsonKey(name: 'like_count')
  final int likesCount;

  ToggleFeedLikeResponseModel({required this.liked, required this.likesCount});

  factory ToggleFeedLikeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ToggleFeedLikeResponseModelFromJson(json);
}
