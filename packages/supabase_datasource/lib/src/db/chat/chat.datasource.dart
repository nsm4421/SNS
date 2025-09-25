import 'package:shared/shared.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/db/chat/chat_room/chat_room_table.datasource.dart';
import 'package:supabase_datasource/src/db/chat/chat_room_member/chat_room_member_table.datasource.dart';
import 'package:supabase_datasource/src/db/chat/dto/add_member_request.dto.dart';
import 'package:supabase_datasource/src/db/chat/dto/create_chat_room_request.dto.dart';
import 'package:supabase_datasource/src/models/chat/chat_room.model.dart';

part 'chat.datasource_impl.dart';

abstract interface class ChatDataSource {
  Future<ChatRoomModel> createChatRoom(CreateChatRoomRequestDto dto);

  Future<Pageable<ChatRoomModel>> getMyChatRooms({
    String? cursor,
    int limit = 30,
  });

  Future<ChatRoomModel> getChatRoomById(String roomId);

  Future<ChatRoomModel> updateChatRoomMeta({
    required String roomId,
    String? name,
    bool? isGroup,
  });

  Future<void> deleteChatRoomById(String roomId);
}
