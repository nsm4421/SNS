import 'package:freezed_annotation/freezed_annotation.dart';

part 'creator.model.g.dart';

part 'creator.model.freezed.dart';

@freezed
@JsonSerializable()
class CreatorModel with _$CreatorModel {
  final String id;
  final String username;

  CreatorModel({required this.id, required this.username});

  factory CreatorModel.fromJson(Map<String, dynamic> json) =>
      _$CreatorModelFromJson(json);
}
