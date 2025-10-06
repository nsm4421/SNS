import 'dart:async';

import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/models/vo/message_change_event.vo.dart';
import 'package:supabase_datasource/src/models/vo/presence_state.vo.dart';
import 'package:supabase_datasource/src/models/vo/realtime_connection_state.vo.dart';
import 'package:supabase_datasource/src/realtime/chat/dto/typing_event.dto.dart';

part 'chat_room.channel_impl.dart';

abstract interface class ChatRoomChannel {
  String get roomId;

  /// 메시지 변경 구독 (insert/update/delete)
  /// - 서버 RLS가 걸려 있으므로 현재 사용자 권한 범위 내에서만 이벤트가 도착
  Stream<MessageChangeEventVo> get messageChangeStream;

  /// 타이핑 인디케이터 (선택)
  /// - 간단한 브로드캐스트(typing:true/false)를 데이터 메시지로 송신/수신
  Stream<TypingEventDto> get typingStream;

  /// 채널 단위 연결 상태
  Stream<RealtimeConnStateVo> get channelStateStream;

  /// Presence: 현재 접속자 목록(동기화 시점 전체 스냅샷)
  /// - `presence.track()`으로 내가 들어왔음을 서버에 알리고,
  ///   `presenceState()`를 반영한 스냅샷을 스트림으로 제공
  Stream<PresenceStateVo> get presenceStream;

  /// Presence에 내가 올릴 payload (예: {user_id, username, joined_at, ...})
  Future<void> trackPresence(PresencePayload payload);

  /// Presence 트래킹 중단(채널 unsubscribe 시 자동)
  Future<void> untrackPresence();

  /// isTyping=true/false를 방 브로드캐스트로 송신
  Future<void> sendTyping({required bool isTyping});

  /// 채널 구독 시작 (필요 시 명시적으로 호출)
  Future<void> subscribe();

  /// 채널 종료/해제
  Future<void> unsubscribe();
}
