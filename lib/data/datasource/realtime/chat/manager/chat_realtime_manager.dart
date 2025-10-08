import 'dart:async';

import '../channel/chat_room.channel.dart';
import 'package:karma/data/model/model.export.dart';

abstract class ChatRealtimeManager {
  bool get disposed;

  /// 방(roomId)용 채널을 준비/획득
  ChatRoomChannel getRoomChannel(String roomId);

  /// 전체 연결 상태 스트림 (인터넷/웹소켓 재연결 등)
  Stream<RealtimeConnStateDto> get connectionStateStream;

  /// 정리
  Future<void> dispose();
}
