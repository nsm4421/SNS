part of 'dm_realtime.datasource_impl.dart';

abstract interface class DmRealtimeDataSource {
  Stream<DmConversationsRow> genConversationChannel({
    required void Function(DmConversationsRow e) onInsert,
    required void Function(DmConversationsRow e) onUpdate,
    required void Function(DmConversationsRow e) onDelete,
  });
}
