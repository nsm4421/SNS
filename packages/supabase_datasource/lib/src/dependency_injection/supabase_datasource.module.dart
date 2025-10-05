import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/auth/local/go_true_async_storage.datasource.dart';
import 'package:supabase_datasource/src/db/chat/chat.datasource.dart';
import 'package:supabase_datasource/src/db/chat/chat_message/chat_messages_table.datasource.dart';
import 'package:supabase_datasource/src/db/chat/chat_room/chat_room_table.datasource.dart';
import 'package:supabase_datasource/src/db/chat/chat_room_member/chat_room_member_table.datasource.dart';
import 'package:supabase_datasource/src/db/profiles/profiles_table.datasource.dart';
import 'package:supabase_datasource/src/env/env.dart';
import 'package:supabase_datasource/src/models/supabase/database.dart';
import 'package:supabase_datasource/src/realtime/chat/manager/chat_realtime_manager.dart';
import 'package:supabase_datasource/supabase_datasource.dart';

@module
abstract class SupabaseDataSourceModule extends LoggerUtil {
  final SupabaseClient _client = SupabaseClient(
    Env.supabaseUrl,
    Env.supabaseAnonKey,
    authOptions: AuthClientOptions(
      authFlowType: AuthFlowType.pkce,
      pkceAsyncStorage: GoTrueAsyncStorageDataSourceImpl(
        FlutterSecureStorage(),
      ),
      // redirectTo: 'io.your.app://callback', // OAuth 쓸 때만
      // autoRefreshToken: true, persistSession: true, // 필요 시
    ),
  );

  @lazySingleton
  AuthDataSource get auth =>
      SupabaseAuthDataSourceImpl(_client.auth, logger: logger);

  @lazySingleton
  ProfilesTableDataSource get profileTable =>
      SupabaseProfileTableDataSourceImpl(ProfilesTable(), logger: logger);

  @lazySingleton
  ChatDataSource get chatTable => SupabaseChatDataSourceImpl(
    client: _client,
    logger: logger,
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

  @lazySingleton
  ChatRealtimeManager get chatRealtime =>
      SupabaseChatRealtimeManagerImpl(_client, logger: logger);
}
