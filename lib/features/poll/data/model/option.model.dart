import 'package:freezed_annotation/freezed_annotation.dart';

part 'option.model.g.dart';

part 'option.model.freezed.dart';

@freezed
@JsonSerializable()
class OptionModel with _$OptionModel {
  final String id;
  final String content;
  final Iterable<$VoteCount> children;

  OptionModel({
    required this.id,
    required this.content,
    required this.children,
  });

  int get voteCount => children.first.count;

  factory OptionModel.fromJson(Map<String, dynamic> json) =>
      _$OptionModelFromJson(json);
}

@freezed
@JsonSerializable()
class $VoteCount with _$$VoteCount {
  final int count;

  $VoteCount({this.count = 0});

  factory $VoteCount.fromJson(Map<String, dynamic> json) =>
      _$$VoteCountFromJson(json);
}
