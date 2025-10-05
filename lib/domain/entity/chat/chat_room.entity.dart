import 'package:copy_with_extension/copy_with_extension.dart';

part 'chat_room.entity.g.dart';

@CopyWith(copyWithNull: true)
class ChatRoomEntity {
  final String id;
  final bool isGroup;
  final String? name;
  final DateTime? lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatRoomEntity({
    required this.id,
    this.isGroup = false,
    this.name,
    this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
  });
}
