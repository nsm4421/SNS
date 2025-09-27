import 'package:freezed_annotation/freezed_annotation.dart';

enum MessageChangeType { insert, update, delete }

@immutable
class MessageChangeEvent {
  final MessageChangeType type;
  final Map<String, dynamic> record; // new_record or old_record
  final Map<String, dynamic>? oldRecord; // update/delete 시 이전 값 (있을 수 있음)
  const MessageChangeEvent({
    required this.type,
    required this.record,
    this.oldRecord,
  });
}
