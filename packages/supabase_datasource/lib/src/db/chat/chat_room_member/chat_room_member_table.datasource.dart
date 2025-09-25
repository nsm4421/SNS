import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/db/chat/dto/add_member_request.dto.dart';
import 'package:supabase_datasource/src/db/exception/db_error_handler_mixin.dart';
import 'package:supabase_datasource/src/models/supabase/database.dart';

part 'chat_room_member_table.datasource_impl.dart';

abstract interface class ChatRoomMembersTableDataSource {
  Future<ChatRoomMembersRow> create(AddMemberRequestDto dto);

  Future<Iterable<ChatRoomMembersRow>> findByRoomId(String roomId);

  Future<void> deleteByRoomId(String roomId);
}
