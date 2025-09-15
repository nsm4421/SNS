import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:sns/domain/entity/base/base.entity.dart';
import 'package:sns/domain/entity/base/creator.entity.dart';

part 'dm_message.entity.g.dart';

@CopyWith(copyWithNull: true)
class DmMessageEntity extends BaseEntity {
  DmMessageEntity({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required this.senderId,
    required this.content,
  });

  final String senderId;
  final String content;
}
