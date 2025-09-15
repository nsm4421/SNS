import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:sns/domain/entity/base/base.entity.dart';

part 'dm_conversation.entity.g.dart';

@CopyWith(copyWithNull: true)
class DmConversationEntity extends BaseEntity {
  DmConversationEntity({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required this.otherUserId,
    required this.otherUsername,
    this.lastMessageId,
    this.lastMessageCreatedAt,
    this.lastMessageContent,
    this.isUnReadMessageExist = false,
    this.lastMessageSenderId,
  });

  final String otherUserId;
  final String otherUsername;
  final String? lastMessageId;
  final DateTime? lastMessageCreatedAt;
  final String? lastMessageContent;
  final bool isUnReadMessageExist;
  final String? lastMessageSenderId;
}
