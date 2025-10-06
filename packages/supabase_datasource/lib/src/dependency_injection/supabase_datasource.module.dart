import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/auth/local/go_true_async_storage.datasource.dart';
import 'package:supabase_datasource/src/db/chat/dm/message/dm_message.datasource.dart';
import 'package:supabase_datasource/src/db/chat/dm/room/dm_room.datasource.dart';
import 'package:supabase_datasource/src/db/chat/dm/room_read_state/dm_read_state.datasource.dart';
import 'package:supabase_datasource/src/env/env.dart';
import 'package:supabase_datasource/src/models/supabase/database.dart';
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
  DmDataSource get dm => SupabaseDmDataSourceImpl(
    logger: logger,
    currentUserId: _client.auth.currentUser!.id,
    dmRoomDataSource: SupabaseDmRoomDataSourceImpl(
      dmRoomsTable: DmRoomsTable(),
      vMyDmRoomsTable: VMyDmRoomsTable(),
    ),
    dmMessageDataSource: SupabaseDmMessageDataSourceImpl(
      dmMessagesTable: DmMessagesTable(),
      vMyDmMessagesTable: VMyDmMessagesTable(),
    ),
    dmRoomReadStateDataSource: SupabaseDmRoomReadStateDataSourceImpl(
      DmRoomReadStateTable(),
    ),
  );

  @lazySingleton
  DmRealtimeManager get dmRealtime =>
      SupabaseDmRealtimeManagerImpl(_client, logger: logger);
}
