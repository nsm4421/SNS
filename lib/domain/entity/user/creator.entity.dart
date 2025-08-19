import '../base.entity.dart';

abstract class CreatorEntity extends AbsEntity {
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
