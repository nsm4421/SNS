part of 'dm_realtime_manager.dart';

class SupabaseDmRealtimeManagerImpl implements DmRealtimeManager {
  SupabaseDmRealtimeManagerImpl(this._client, {Logger? logger}) {
    _disposed = false;
    _channels = {};
    _connectionCtrl = StreamController<RealtimeConnStateVo>.broadcast(
      sync: true,
    );
    _logger = logger;
  }

  final SupabaseClient _client;
  late final StreamController<RealtimeConnStateVo> _connectionCtrl;
  late final Map<String, SupabaseChatRoomChannelImpl> _channels;
  late bool _disposed;
  late final Logger? _logger;

  @override
  bool get disposed => _disposed;

  @override
  Stream<RealtimeConnStateVo> get connectionStateStream =>
      _connectionCtrl.stream;

  void _emitConn(bool ok, {String? reason}) {
    if (_disposed) return;
    _connectionCtrl.add(RealtimeConnStateVo(ok, reason: reason));
  }

  @override
  ChatRoomChannel getRoomChannel(String roomId) {
    return _channels.putIfAbsent(
      roomId,
      () => SupabaseChatRoomChannelImpl(
        roomId: roomId,
        client: _client,
        chatRoomTableName: 'dm_rooms',
        chatMessageTableName: 'dm_messages',
        onChannelState: (s) => _emitConn(s.isConnected, reason: s.reason),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    for (final channel in _channels.values) {
      await channel.unsubscribe();
    }
    _channels.clear();
    await _connectionCtrl.close();
  }
}
