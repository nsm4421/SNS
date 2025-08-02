import 'creator.entity.dart';

abstract class BaseEntity {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BaseEntity({required this.id, this.createdAt, this.updatedAt});
}

abstract class BaseEntityWithUser extends BaseEntity {
  final CreatorEntity creator;

  BaseEntityWithUser({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required this.creator,
  });
}
