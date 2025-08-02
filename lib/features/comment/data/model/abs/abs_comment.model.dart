import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/core/core.export.dart';

part 'abs_comment.model.g.dart';

part 'abs_comment.model.freezed.dart';

@freezed
@JsonSerializable()
class AbsCommentModel with _$AbsCommentModel {
  final String id;
  final String content;
  @JsonKey(name: 'ref_id')
  final String refId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'creator')
  final CreatorModel creator;

  AbsCommentModel({
    required this.id,
    required this.content,
    required this.refId,
    this.createdAt,
    this.updatedAt,
    required this.creator,
  });

  factory AbsCommentModel.fromJson(Map<String, dynamic> json) =>
      _$AbsCommentModelFromJson(json);
}
