import 'package:fpdart/fpdart.dart';
import 'package:karma/domain/entity/chat/chat_message.entity.dart';
import 'package:karma/domain/entity/chat/chat_room.entity.dart';
import 'package:shared/shared.dart';
import 'package:supabase_datasource/supabase_datasource.dart';

abstract interface class ChatRepository {
  /// 방 생성
  Future<Either<Failure, ChatRoomEntity>> createRoom({
    String? clientRoomId,
    required String name,
    required Iterable<String> memberIds,
    bool isGroup = false,
  });

  /// 내 채팅방 목록 (커서 기반 페이지네이션)
  Future<Either<Failure, Pageable<ChatRoomEntity>>> fetchRooms({
    required String cursor,
    int limit = 30,
  });

  /// 방 상세
  Future<Either<Failure, ChatRoomEntity>> getRoom(String roomId);

  /// 방 메타 업데이트
  Future<Either<Failure, ChatRoomEntity>> updateRoomMeta({
    required String roomId,
    String? name,
    bool isGroup = false,
  });

  /// 방 삭제
  Future<Either<Failure, Unit>> deleteRoom(String roomId);

  /// 메시지 전송
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String roomId,
    required String senderId,
    required String content,
    MessageType msgType = MessageType.text,
    String? clientMessageId, // 낙관적 UI/중복 방지용
    Map<String, dynamic>? metadata,
  });

  /// 메시지 목록 (커서 기반 페이지네이션)
  Future<Either<Failure, Pageable<ChatMessageEntity>>> fetchMessages({
    required String roomId,
    required String cursor,
    int limit = 30,
  });

  ChatRoomChannel getRoomChannel(String roomId);
}
