import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/data/datasource/datasource.export.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_codegen/supabase_codegen.dart';

import 'package:karma/core/core.export.dart';
import 'auth/local/go_true_async_storage.datasource.dart';
import 'db/chat/dm/message/dm_message.datasource.dart';
import 'db/chat/dm/room/dm_room.datasource.dart';
import 'db/chat/dm/room_read_state/dm_read_state.datasource.dart';
import 'package:karma/data/datasource/storage/storage.datasource.dart';
import 'rpc/feed/feed_rpc.datasource.dart';

@module
abstract class DataSourceModule {
  final FlutterSecureStorage _flutterSecureStorage =
      const FlutterSecureStorage();
  late final SupabaseClient _client = setClient(
    SupabaseClient(
      Env.supabaseApiUrl,
      Env.supabaseAnonKey,
      authOptions: AuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        pkceAsyncStorage: GoTrueAsyncStorageDataSourceImpl(
          _flutterSecureStorage,
        ),
        // redirectTo: 'io.your.app://callback', // OAuth 쓸 때만
        // autoRefreshToken: true, persistSession: true, // 필요 시
      ),
    ),
  );
  final _dio = Dio();

  @lazySingleton
  LocalTokenDataSource get localToken => LocalTokenDataSourceImpl(
    flutterSecureStorage: _flutterSecureStorage,
    logger: appLogger,
  );

  @lazySingleton
  RemoteAuthDataSource get auth =>
      SupabaseAuthDataSourceImpl(client: _client, logger: appLogger);

  @lazySingleton
  ProfilesTableDataSource get profileTables =>
      SupabaseProfileTableDataSourceImpl(ProfilesTable(), logger: appLogger);

  @lazySingleton
  DmDataSource get dmTables => SupabaseDmDataSourceImpl(
    logger: appLogger,
    client: _client,
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
      SupabaseDmRealtimeManagerImpl(client: _client, logger: appLogger);

  @lazySingleton
  FeedTablesDataSource get feedTables => SupabaseFeedTablesDataSourceImpl(
    client: _client,
    postView: VFeedListTable(),
    commentView: VFeedCommentListTable(),
    postsTable: FeedPostsTable(),
    postLikesTable: FeedPostLikesTable(),
    commentTable: FeedCommentsTable(),
    mediaTable: FeedMediaTable(),
    logger: appLogger,
  );

  @lazySingleton
  UserPresenceDataSource get userPresence =>
      SupabaseUserPresenceDataSourceImpl(client: _client, logger: appLogger);

  @lazySingleton
  FeedBucketDataSource get feedBucket =>
      SupabaseFeedBucketDataSourceImpl(storageDataSource: _storage);

  @lazySingleton
  FeedRpcDataSource get feedRpc => FeedRpcDataSourceImpl(client: _client);

  @lazySingleton
  StorageDataSource get _storage =>
      SupabaseStorageDataSourceImpl(client: _client, dio: _dio);
}
