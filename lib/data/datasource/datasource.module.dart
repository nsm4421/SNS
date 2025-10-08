import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_codegen/supabase_codegen.dart';

import 'package:karma/core/core.export.dart';
import 'auth/local/go_true_async_storage.datasource.dart';
import 'auth/remote/remote_auth_datasource.dart';
import 'db/chat/dm/dm_datasource.dart';
import 'db/chat/dm/message/dm_message.datasource.dart';
import 'db/chat/dm/room/dm_room.datasource.dart';
import 'db/chat/dm/room_read_state/dm_read_state.datasource.dart';
import 'db/profiles/profiles_table.datasource.dart';
import 'db/generated/database.dart';
import 'realtime/chat/manager/dm_realtime_manager.dart';
import 'realtime/presence/user_presence.datasource.dart';

@module
abstract class DataSourceModule {
  final SupabaseClient _client = setClient(
    SupabaseClient(
      Env.supabaseApiUrl,
      Env.supabaseAnonKey,
      authOptions: const AuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        pkceAsyncStorage: GoTrueAsyncStorageDataSourceImpl(
          FlutterSecureStorage(),
        ),
        // redirectTo: 'io.your.app://callback', // OAuth 쓸 때만
        // autoRefreshToken: true, persistSession: true, // 필요 시
      ),
    ),
  );

  @lazySingleton
  RemoteAuthDataSource get auth =>
      SupabaseAuthDataSourceImpl(_client.auth, logger: appLogger);

  @lazySingleton
  ProfilesTableDataSource get profileTable =>
      SupabaseProfileTableDataSourceImpl(_profilesTable, logger: appLogger);

  @lazySingleton
  DmDataSource get dm => SupabaseDmDataSourceImpl(
    logger: appLogger,
    currentUserId: _client.auth.currentUser!.id,
    dmRoomDataSource: SupabaseDmRoomDataSourceImpl(
      dmRoomsTable: _dmRoomsTable,
      vMyDmRoomsTable: _dmRoomsView,
    ),
    dmMessageDataSource: SupabaseDmMessageDataSourceImpl(
      dmMessagesTable: _dmMessagesTable,
      vMyDmMessagesTable: _dmMessagesView,
    ),
    dmRoomReadStateDataSource: SupabaseDmRoomReadStateDataSourceImpl(
      _dmRoomReadStateTable,
    ),
  );

  @lazySingleton
  DmRealtimeManager get dmRealtime =>
      SupabaseDmRealtimeManagerImpl(_client, logger: appLogger);

  @lazySingleton
  UserPresenceDataSource get userPresence =>
      SupabaseUserPresenceDataSourceImpl(_client, logger: appLogger);

  @lazySingleton
  ProfilesTable get _profilesTable => ProfilesTable();

  @lazySingleton
  DmRoomsTable get _dmRoomsTable => DmRoomsTable();

  @lazySingleton
  DmMessagesTable get _dmMessagesTable => DmMessagesTable();

  @lazySingleton
  VMyDmRoomsTable get _dmRoomsView => VMyDmRoomsTable();

  @lazySingleton
  VMyDmMessagesTable get _dmMessagesView => VMyDmMessagesTable();

  @lazySingleton
  DmRoomReadStateTable get _dmRoomReadStateTable => DmRoomReadStateTable();
}
