part of 'chat_room.channel.dart';

class SupabaseChatRoomChannelImpl implements ChatRoomChannel {
  SupabaseChatRoomChannelImpl({
    required SupabaseClient client,
    required String roomId,
    required String chatRoomTableName,
    required String chatMessageTableName,
    required void Function(RealtimeConnStateDto state) onChannelState,
  }) : _client = client,
       _onChannelState = onChannelState {
    _roomId = roomId;
    _chatRoomTableName = chatRoomTableName;
    _chatMessageTableName = chatMessageTableName;
    _messageController = StreamController<MessageChangeEventDto>.broadcast(
      sync: true,
    );
    _presenceController = StreamController<PresenceStateDto>.broadcast(
      sync: true,
    );
    _typingController = StreamController<TypingEventDto>.broadcast(sync: true);
    _stateController = StreamController<RealtimeConnStateDto>.broadcast(
      sync: true,
    );
    _subscribed = false;
    _pgChangeChannelInitialized = false;
    _presenceChannelInitialized = false;
  }

  final SupabaseClient _client;

  final void Function(RealtimeConnStateDto state) _onChannelState;

  late final String _roomId;
  late final String _chatRoomTableName;
  late final String _chatMessageTableName;
  late final StreamController<MessageChangeEventDto> _messageController;
  late final StreamController<PresenceStateDto> _presenceController;
  late final StreamController<TypingEventDto> _typingController;
  late final StreamController<RealtimeConnStateDto> _stateController;
  late bool _subscribed;
  late bool _pgChangeChannelInitialized;
  late bool _presenceChannelInitialized;
  late final RealtimeChannel _$pgChangeChannel; // 메시지 테이블 변경 구독
  late final RealtimeChannel _$presenceChannel; // presence + typing 브로드캐스트

  @override
  String get roomId => _roomId;

  @override
  Stream<MessageChangeEventDto> get messageChangeStream =>
      _messageController.stream;

  @override
  Stream<PresenceStateDto> get presenceStream => _presenceController.stream;

  @override
  Stream<TypingEventDto> get typingStream => _typingController.stream;

  @override
  Stream<RealtimeConnStateDto> get channelStateStream => _stateController.stream;

  void _emitState(bool ok, {String? reason}) {
    final s = RealtimeConnStateDto(ok, reason: reason);
    _stateController.add(s);
    _onChannelState.call(s);
  }

  RealtimeChannel get _pgChangeChannel {
    if (_pgChangeChannelInitialized) {
      return _$pgChangeChannel;
    }
    final filter = PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'room_id',
      value: roomId,
    );
    _$pgChangeChannel =
        _client.channel('$_chatMessageTableName:$roomId:changes')
          ..onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: _chatMessageTableName,
            filter: filter,
            callback: (payload) {
              _messageController.add(
                MessageChangeEventDto(
                  type: MessageChangeType.insert,
                  record: payload.newRecord,
                ),
              );
            },
          )
          ..onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: _chatRoomTableName,
            filter: filter,
            callback: (payload) {
              _messageController.add(
                MessageChangeEventDto(
                  type: MessageChangeType.update,
                  record: payload.newRecord,
                  oldRecord: payload.oldRecord,
                ),
              );
            },
          )
          ..onPostgresChanges(
            event: PostgresChangeEvent.delete,
            schema: 'public',
            table: _chatRoomTableName,
            filter: filter,
            callback: (payload) {
              _messageController.add(
                MessageChangeEventDto(
                  type: MessageChangeType.delete,
                  record: payload.oldRecord,
                ),
              );
            },
          );
    _pgChangeChannelInitialized = true;
    return _$pgChangeChannel;
  }

  RealtimeChannel get _presenceChannel {
    if (_presenceChannelInitialized) {
      return _$presenceChannel;
    }
    _$presenceChannel = _client.channel('$_chatRoomTableName:$roomId:presence')
      ..onPresenceSync((_) {
        _$presenceChannel
            .presenceState()
            .map((e) => {e.key: e.presences.map((p) => p.payload).toList()})
            .map(PresenceStateDto.new)
            .forEach(_presenceController.add);
      })
      ..onBroadcast(
        event: 'typing',
        callback: (payload) {
          _typingController.add(
            TypingEventDto.fromJson(payload),
          );
        },
      );
    _presenceChannelInitialized = true;
    return _$presenceChannel;
  }

  @override
  Future<void> subscribe() async {
    if (_subscribed) return;
    _pgChangeChannel.subscribe((status, error) {
      switch (status) {
        case RealtimeSubscribeStatus.subscribed:
          _emitState(true);
        case RealtimeSubscribeStatus.closed:
        case RealtimeSubscribeStatus.channelError:
        case RealtimeSubscribeStatus.timedOut:
          _emitState(false, reason: error?.toString());
      }
    });
    _presenceChannel.subscribe((status, error) {
      switch (status) {
        case RealtimeSubscribeStatus.subscribed:
          _emitState(true);
        case RealtimeSubscribeStatus.closed:
        case RealtimeSubscribeStatus.channelError:
        case RealtimeSubscribeStatus.timedOut:
          _emitState(false, reason: error?.toString());
      }
    });
    _subscribed = true;
  }

  @override
  Future<void> unsubscribe() async {
    if (!_subscribed) return;
    try {
      await untrackPresence();
      await _presenceChannel.unsubscribe();
      await _pgChangeChannel.unsubscribe();
    } finally {
      _subscribed = false;
      _emitState(false, reason: 'unsubscribed');
    }
  }

  @override
  Future<void> trackPresence(PresencePayload payload) async {
    await _presenceChannel.track(payload);
  }

  @override
  Future<void> untrackPresence() async {
    await _presenceChannel.untrack();
  }

  @override
  Future<void> sendTyping({required bool isTyping}) async {
    final currentUid = _client.auth.currentUser?.id;
    if (currentUid == null) return;
    await _presenceChannel.sendBroadcastMessage(
      event: 'typing',
      payload: TypingEventDto(
        userId: currentUid,
        isTyping: isTyping,
        at: DateTime.now().toUtc(),
      ).toJson(),
    );
  }
}
