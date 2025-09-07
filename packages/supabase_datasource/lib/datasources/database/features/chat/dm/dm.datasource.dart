part of 'dm.datasource_impl.dart';

abstract interface class SupabaseDirectMessageDataSource {
  DmConversationDataSource get conversation;

  DmMessageDataSource get message;

  DmRealtimeDataSource get realtime;
}
