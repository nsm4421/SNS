import 'package:injectable/injectable.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/auth/auth_datasource.dart';
import 'package:supabase_datasource/src/db/chat/chat.datasource.dart';
import 'package:supabase_datasource/src/db/chat/chat_message/chat_messages_table.datasource.dart';
import 'package:supabase_datasource/src/db/chat/chat_room/chat_room_table.datasource.dart';
import 'package:supabase_datasource/src/db/chat/chat_room_member/chat_room_member_table.datasource.dart';
import 'package:supabase_datasource/src/db/profiles/profiles_table.datasource.dart';
import 'package:supabase_datasource/src/env/env.dart';
import 'package:supabase_datasource/src/models/supabase/database.dart';

@module
abstract class SupabaseModule {
  final SupabaseClient _client = SupabaseClient(
    Env.supabaseUrl,
    Env.supabaseAnonKey,
  );

  @lazySingleton
  AuthDatasource get auth => SupabaseAuthDataSourceImpl(_client.auth);

  @lazySingleton
  ProfilesTableDataSource get profileTable =>
      SupabaseProfileTableDataSourceImpl(ProfilesTable());

  @lazySingleton
  ChatDataSource get chat => SupabaseChatDataSourceImpl(
    client: _client,
    chatRoomsTableDatSource: SupabaseChatRoomsTableDataSourceImpl(
      ChatRoomsTable(),
    ),
    chatRoomMembersTableDataSource: SupabaseChatRoomMembersTableDataSourceImpl(
      ChatRoomMembersTable(),
    ),
    chatMessagesTableDataSource: SupabaseChatMessagesTableDataSourceImpl(
      ChatMessagesTable(),
    ),
  );
}
