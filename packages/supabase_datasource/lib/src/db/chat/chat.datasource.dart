import 'package:logger/logger.dart';
import 'package:shared/shared.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/db/chat/chat_message/chat_messages_table.datasource.dart';
import 'package:supabase_datasource/src/db/chat/chat_room/chat_room_table.datasource.dart';
import 'package:supabase_datasource/src/db/chat/chat_room_member/chat_room_member_table.datasource.dart';
import 'package:supabase_datasource/src/db/chat/dto/add_member_request.dto.dart';
import 'package:supabase_datasource/src/db/chat/dto/create_chat_room_request.dto.dart';
import 'package:supabase_datasource/src/db/chat/dto/send_message_request.dto.dart';
import 'package:supabase_datasource/src/models/chat/chat_message.model.dart';
import 'package:supabase_datasource/src/models/chat/chat_room.model.dart';

part 'chat.datasource_impl.dart';

abstract interface class ChatDataSource {
  /// chat room
  // TODO : 채팅방 프로필사진이나 메타데이터 필드 추가
  Future<ChatRoomModel> createRoom(CreateChatRoomRequestDto dto);

  Future<Pageable<ChatRoomModel>> fetchMyRooms({
    required String cursor,
    int limit = 30,
  });

  Future<ChatRoomModel> getRoomById(String roomId);

  // TODO : 채팅방 프로필사진이나 메타데이터 수정기능 추가
  Future<ChatRoomModel> updateRoomMeta({
    required String roomId,
    String? name,
    bool isGroup = false,
  });

  Future<void> deleteRoomById(String roomId);

  /// chat message
  Future<ChatMessageModel> sendMessage(SendMessageRequestDto dto);

  Future<Pageable<ChatMessageModel>> fetchMessageByRoomId({
    required String roomId,
    required String cursor,
    int limit = 30,
  });
}
