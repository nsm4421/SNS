part of 'dm_realtime.datasource_impl.dart';

abstract interface class DmRealtimeDataSource {
  Stream<StreamPayloadWrapper<DmConversationsRow>> genConversationChannel();

  Stream<StreamPayloadWrapper<DmMessagesRow>> getMessageChannel(String conversationId);
}
