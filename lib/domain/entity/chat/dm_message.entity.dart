import 'package:copy_with_extension/copy_with_extension.dart';

part 'dm_message.entity.g.dart';

@CopyWith(copyWithNull: true)
class DmMessageEntity {
  final String id;
  final String roomId;
  final String senderId;
  final String? content;
  final String msgType;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? deletedAt;

  DmMessageEntity({
    required this.id,
    required this.roomId,
    required this.senderId,
    this.content = '',
    this.msgType = 'text',
    this.metadata,
    required this.createdAt,
    this.deletedAt,
  });
}
