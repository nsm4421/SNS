import 'package:supabase_datasource/datasources/database/generated/database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'dm_realtime.datasource.dart';

class DmReltimeDataSourceImpl implements DmRealtimeDataSource {
  final SupabaseClient _client;
  static const String _conversationChannelName = "DM_CONVERSATION";
  static const String _messageChannelNamePrefix = "DM_MESSAGE";

  DmReltimeDataSourceImpl(this._client);

  Stream<DmConversationsRow> genConversationChannel({
    required void Function(DmConversationsRow e) onInsert,
    required void Function(DmConversationsRow e) onUpdate,
    required void Function(DmConversationsRow e) onDelete,
  }) {
    return Stream<DmConversationsRow>.multi((controller) {
      final tableName = DmConversationsTable().tableName;
      final channel =
          _client
              .channel(_conversationChannelName)
              .onPostgresChanges(
                event: PostgresChangeEvent.insert,
                table: tableName,
                callback: (payload) {
                  onInsert(DmConversationsRow.fromJson(payload.newRecord));
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.update,
                table: tableName,
                callback: (payload) {
                  onUpdate(DmConversationsRow.fromJson(payload.newRecord));
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.delete,
                table: tableName,
                callback: (payload) {
                  onDelete(DmConversationsRow.fromJson(payload.oldRecord));
                },
              )
            ..subscribe();

      controller.onCancel = () async {
        await channel.unsubscribe();
        await _client.removeChannel(channel);
      };
    }, isBroadcast: true);
  }

  Stream<DmMessagesRow> setMessageChannel({
    required String conversationId,
    required void Function(DmMessagesRow e) onInsert,
    required void Function(DmMessagesRow e) onDelete,
  }) {
    return Stream<DmMessagesRow>.multi((controller) {
      final tableName = DmMessagesTable().tableName;
      final filter = PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'conversation_id',
        value: conversationId,
      );
      final channel =
          _client
              .channel('${_messageChannelNamePrefix}_$conversationId')
              .onPostgresChanges(
                event: PostgresChangeEvent.insert,
                table: tableName,
                filter: filter,
                callback: (payload) {
                  onInsert(DmMessagesRow.fromJson(payload.newRecord));
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.delete,
                table: tableName,
                filter: filter,
                callback: (payload) {
                  onDelete(DmMessagesRow.fromJson(payload.oldRecord));
                },
              )
            ..subscribe();

      controller.onCancel = () async {
        await channel.unsubscribe();
        await _client.removeChannel(channel);
      };
    }, isBroadcast: true);
  }
}
