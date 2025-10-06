import 'dart:async';
import 'package:supabase_datasource/src/models/vo/realtime_connection_state.vo.dart';
import 'package:supabase_datasource/src/realtime/chat/channel/chat_room.channel.dart';

abstract class ChatRealtimeManager {
  bool get disposed;

  /// 방(roomId)용 채널을 준비/획득
  ChatRoomChannel getRoomChannel(String roomId);

  /// 전체 연결 상태 스트림 (인터넷/웹소켓 재연결 등)
  Stream<RealtimeConnStateVo> get connectionStateStream;

  /// 정리
  Future<void> dispose();
}
