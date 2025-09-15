import 'package:shared/export.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'dm_realtime.datasource.dart';

class DmReltimeDataSourceImpl implements DmRealtimeDataSource {
  final SupabaseClient _client;
  static const String _conversationChannelName = "DM_CONVERSATION";
  static const String _messageChannelNamePrefix = "DM_MESSAGE";

  DmReltimeDataSourceImpl(this._client);

  @override
  Stream<StreamPayloadWrapper<DmConversationsRow>> genConversationChannel() {
    return Stream<StreamPayloadWrapper<DmConversationsRow>>.multi((controller) {
      final tableName = DmConversationsTable().tableName;
      final channel =
          _client
              .channel(_conversationChannelName)
              .onPostgresChanges(
                event: PostgresChangeEvent.insert,
                table: tableName,
                callback: (payload) {
                  controller.add(
                    StreamPayloadInserted<DmConversationsRow>(
                      inserted: DmConversationsRow.fromJson(payload.newRecord),
                    ),
                  );
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.update,
                table: tableName,
                callback: (payload) {
                  controller.add(
                    StreamPayloadUpdated<DmConversationsRow>(
                      updated: DmConversationsRow.fromJson(payload.newRecord),
                    ),
                  );
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.delete,
                table: tableName,
                callback: (payload) {
                  controller.add(
                    StreamPayloadDeleted<DmConversationsRow>(
                      deleted: DmConversationsRow.fromJson(
                        payload.oldRecord,
                      ).id,
                    ),
                  );
                },
              )
            ..subscribe();

      controller.onCancel = () async {
        await channel.unsubscribe();
        await _client.removeChannel(channel);
      };
    }, isBroadcast: true);
  }

  @override
  Stream<StreamPayloadWrapper<DmMessagesRow>> getMessageChannel(
    String conversationId,
  ) {
    return Stream<StreamPayloadWrapper<DmMessagesRow>>.multi((controller) {
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
                  controller.add(
                    StreamPayloadInserted<DmMessagesRow>(
                      inserted: DmMessagesRow.fromJson(payload.newRecord),
                    ),
                  );
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.update,
                table: tableName,
                filter: filter,
                callback: (payload) {
                  controller.add(
                    StreamPayloadUpdated<DmMessagesRow>(
                      updated: DmMessagesRow.fromJson(payload.newRecord),
                    ),
                  );
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.delete,
                table: tableName,
                filter: filter,
                callback: (payload) {
                  controller.add(
                    StreamPayloadDeleted<DmMessagesRow>(
                      deleted: DmMessagesRow.fromJson(payload.oldRecord).id,
                    ),
                  );
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
