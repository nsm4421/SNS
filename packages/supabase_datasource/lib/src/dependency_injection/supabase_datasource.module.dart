import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_codegen/supabase_codegen.dart';
import 'package:supabase_datasource/src/auth/local/go_true_async_storage.datasource.dart';
import 'package:supabase_datasource/src/db/chat/dm/message/dm_message.datasource.dart';
import 'package:supabase_datasource/src/db/chat/dm/room/dm_room.datasource.dart';
import 'package:supabase_datasource/src/db/chat/dm/room_read_state/dm_read_state.datasource.dart';
import 'package:supabase_datasource/src/env/env.dart';
import 'package:supabase_datasource/src/models/supabase/database.dart';
import 'package:supabase_datasource/supabase_datasource.dart';

@module
abstract class SupabaseDataSourceModule extends LoggerUtil {
  late final SupabaseClient _client;

  // auth datasource가 가장 먼저 사용됨
  // auth datasource에 의존성 주입할 때 SupabaseClient를 초기화하고,
  // supabase codedgen client도 초기화
  @lazySingleton
  AuthDataSource get auth {
    _client = SupabaseClient(
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
    );
    setClient(_client);
    return SupabaseAuthDataSourceImpl(_client.auth, logger: logger);
  }

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
