import 'package:freezed_annotation/freezed_annotation.dart';

part 'vote.model.g.dart';

part 'vote.model.freezed.dart';

@freezed
@JsonSerializable()
class VoteModel with _$VoteModel {
  final String id;
  @JsonKey(name: "option_id")
  final String optionId;
  final String? createdAt;

  VoteModel({required this.id, required this.optionId, this.createdAt});

  factory VoteModel.fromJson(Map<String, dynamic> json) =>
      _$VoteModelFromJson(json);
}
