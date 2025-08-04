import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/core/core.export.dart';

part 'option.model.g.dart';

part 'option.model.freezed.dart';

@freezed
@JsonSerializable()
class OptionModel with _$OptionModel implements BaseModel {
  final String id;
  final String content;
  final int seq;
  @JsonKey(name: 'vote_count')
  final int voteCount;
  @JsonKey(name: 'voted_by_me')
  final bool votedByMe;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  OptionModel({
    required this.id,
    required this.content,
    required this.seq,
    this.voteCount = 0,
    this.votedByMe = false,
    this.createdAt,
    this.updatedAt,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) =>
      _$OptionModelFromJson(json);
}
