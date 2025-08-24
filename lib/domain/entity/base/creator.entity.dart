import 'base.entity.dart';

abstract class CreatorEntity extends BaseEntity {
  CreatorEntity({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required this.username,
    this.profileImage,
  });

  final String username;
  final String? profileImage;
}

class BaseEntityWithCreator extends BaseEntity {
  final CreatorEntity creator;

  BaseEntityWithCreator({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required this.creator,
  });
}
