import 'package:karma/data/datasource/db/generated/database.dart';

class DmMessageModel {
  final String id;
  final String roomId;
  final String senderId;
  final String? content;
  final MessageType msgType;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? deletedAt;

  DmMessageModel({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    this.msgType = MessageType.text,
    this.metadata,
    required this.createdAt,
    this.deletedAt,
  });

  factory DmMessageModel.fromRow(VMyDmMessagesRow row) {
    return DmMessageModel(
      id: row.messageId ?? '',
      roomId: row.roomId ?? '',
      senderId: row.senderId ?? '',
      content: row.content,
      msgType: MessageType.values.firstWhere((e) => e.name == row.msgType),
      metadata: row.metadata,
      createdAt: row.createdAt!,
      deletedAt: row.deletedAt,
    );
  }
}
