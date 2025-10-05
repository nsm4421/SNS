import 'package:copy_with_extension/copy_with_extension.dart';

part 'chat_message.entity.g.dart';

@CopyWith(copyWithNull: true)
class ChatMessageEntity {
  final String id;
  final String roomId;
  final String senderId;
  final String? content;
  final String msgType;
  final DateTime createdAt;
  final DateTime? editedAt;
  final DateTime? deletedAt;

  ChatMessageEntity({
    required this.id,
    required this.roomId,
    required this.senderId,
    this.content,
    this.msgType = 'text',
    required this.createdAt,
    this.editedAt,
    this.deletedAt,
  });
}
