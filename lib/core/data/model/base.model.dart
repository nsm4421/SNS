import 'creator.model.dart';

abstract interface class BaseModel {
  final String id;
  final String? createdAt;
  final String? updatedAt;

  BaseModel({required this.id, this.createdAt, this.updatedAt});
}

abstract interface class BaseModelWithUser {
  final String id;
  final String? createdAt;
  final String? updatedAt;
  final CreatorModel creator;

  BaseModelWithUser({
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.creator,
  });
}
