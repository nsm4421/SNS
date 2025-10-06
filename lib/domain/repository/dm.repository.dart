import 'package:fpdart/fpdart.dart';
import 'package:karma/domain/entity/chat/dm_message.entity.dart';
import 'package:karma/domain/entity/chat/dm_room.entity.dart';
import 'package:shared/shared.dart';
import 'package:supabase_datasource/supabase_datasource.dart';

abstract interface class DmRepository {
  // TODO : domain layer에서 supabase_datasource를 import하는게 상당히 거슬림. 나중에 시간되면 refactoring해보기
  Either<Failure, ChatRoomChannel> getChatRoomChannel(String roomId);

  /// 상대와의 DM 방 생성 또는 기존 방 반환
  Future<Either<Failure, DmRoomEntity>> createOrGetRoom(String counterpartId);

  /// 내 DM 방 목록
  Future<Either<Failure, Pageable<DmRoomEntity>>> fetchRooms({
    required String cursor,
    int limit = 30,
  });

  /// 특정 방의 메시지 목록
  Future<Either<Failure, Pageable<DmMessageEntity>>> fetchMessages({
    required String roomId,
    required String cursor,
    int limit = 30,
  });

  /// 텍스트 메시지 전송
  Future<Either<Failure, DmMessageEntity>> sendTextMessage({
    required String roomId,
    required String content,
  });

  /// 읽음 처리
  Future<Either<Failure, Unit>> markAsRead({
    required String roomId,
    required String lastReadMessageId,
  });
}
