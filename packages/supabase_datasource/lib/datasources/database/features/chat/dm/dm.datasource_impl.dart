import 'package:supabase_datasource/datasources/database/features/chat/dm/conversation/dm_conversation.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/features/chat/dm/message/dm_message.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/features/chat/dm/realtime/dm_realtime.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'dm.datasource.dart';

class SupabaseDirectMessageDataSourceImpl
    implements SupabaseDirectMessageDataSource {
  SupabaseDirectMessageDataSourceImpl({
    required SupabaseClient client,
    required DmMessagesTable dmMessagesTable,
    required DmConversationsTable dmConversationsTable,
    required DmConversationsWithUserTable dmConversationsWithUserTable,
  }) : _client = client,
       _dmMessagesTable = dmMessagesTable,
       _dmConversationsTable = dmConversationsTable,
       _dmConversationsWithUserTable = dmConversationsWithUserTable;

  final SupabaseClient _client;
  final DmMessagesTable _dmMessagesTable;
  final DmConversationsTable _dmConversationsTable;
  final DmConversationsWithUserTable _dmConversationsWithUserTable;

  @override
  DmConversationDataSource get conversation => DmConversationDataSourceImpl(
    dmConversationsTable: _dmConversationsTable,
    dmConversationsWithUserTable: _dmConversationsWithUserTable,
  );

  @override
  DmMessageDataSource get message => DmMessageDataSourceImpl(_dmMessagesTable);

  @override
  DmRealtimeDataSource get realtime => DmReltimeDataSourceImpl(_client);
}
