import 'package:sns/core/core.export.dart';

abstract class AbsCommentModel {
  final String id;
  final String refId;
  final String content;
  final String? createdAt;
  final String? updatedAt;
  final CreatorModel creator;

  AbsCommentModel({
    required this.id,
    required this.refId,
    required this.content,
    this.createdAt,
    this.updatedAt,
    required this.creator,
  });
}
