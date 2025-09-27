part of 'chat_realtime_manager.dart';

class SupabaseChatRealtimeManagerImpl implements ChatRealtimeManager {
  SupabaseChatRealtimeManagerImpl(this._client) {
    _disposed = false;
    _channels = {};
    _connectionCtrl = StreamController<RealtimeConnState>.broadcast(
      sync: true,
    );
  }

  final SupabaseClient _client;
  late final StreamController<RealtimeConnState> _connectionCtrl;
  late final Map<String, SupabaseChatRoomChannelImpl> _channels;
  late bool _disposed;

  @override
  bool get disposed => _disposed;

  @override
  Stream<RealtimeConnState> get connectionStateStream => _connectionCtrl.stream;

  void _emitConn(bool ok, {String? reason}) {
    if (_disposed) return;
    _connectionCtrl.add(RealtimeConnState(ok, reason: reason));
  }

  @override
  ChatRoomChannel getRoomChannel(String roomId) {
    return _channels.putIfAbsent(
      roomId,
      () => SupabaseChatRoomChannelImpl(
        roomId: roomId,
        client: _client,
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
