abstract class AbsEntity {
  AbsEntity({required this.id, this.createdAt, this.updatedAt});

  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
