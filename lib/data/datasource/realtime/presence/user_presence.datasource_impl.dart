part of 'user_presence.datasource.dart';

class SupabaseUserPresenceDataSourceImpl implements UserPresenceDataSource {
  final SupabaseClient _client;
  final Logger? _logger;

  SupabaseUserPresenceDataSourceImpl({
    required SupabaseClient client,
    Logger? logger,
  }) : _client = client,
       _logger = logger;

  final String _kPresenceUserIdKey = 'id';

  /// topic -> channel
  final Map<String, RealtimeChannel> _channels = {};

  /// topic -> 마지막 온라인 id 집합
  final Map<String, Set<String>> _onlineIds = {};

  /// topic -> 브로드캐스트 컨트롤러
  final Map<String, StreamController<Set<String>>> _controllers = {};

  @override
  Future<void> enter({
    required String topic,
    required String userId,
    Map<String, dynamic>? metadata,
    bool includeSelfInState = true,
  }) async {
    final channel = _ensureChannel(
      topic,
      includeSelfInState: includeSelfInState,
    )..subscribe();

    // 현재 나의 presence를 알리기
    final PresencePayload payload = {
      _kPresenceUserIdKey: userId,
      if (metadata != null) ...metadata,
      'online_at': DateTime.now().toUtc().toIso8601String(),
    };
    await channel.track(payload);
  }

  @override
  Future<void> leave(String topic) async {
    final channel = _channels.remove(topic);
    await _try(() async {
      await channel?.untrack();
    });
    await _try(() async {
      await channel?.unsubscribe();
    });

    _onlineIds.remove(topic);

    final controller = _controllers.remove(topic);
    await controller?.close();
  }

  @override
  Stream<Set<String>> onlineUserIdsStream(String topic) {
    final controller = _ensureController(topic);
    _ensureChannel(topic); // 리스너 보장

    // 스냅샷이 있으면 즉시 흘려보냄
    final currentUserIds = _onlineIds[topic];
    if (currentUserIds != null && currentUserIds.isNotEmpty) {
      scheduleMicrotask(() => controller.add(Set.unmodifiable(currentUserIds)));
    }

    return controller.stream;
  }

  @override
  Future<void> clearResources() async {
    await Future.wait(_channels.keys.map(leave));
  }

  Future<void> _try(Function callback) async {
    try {
      await callback();
    } catch (e) {
      _logger?.e(e);
    }
  }

  RealtimeChannel _ensureChannel(
    String topic, {
    bool includeSelfInState = true,
  }) {
    final exist = _channels[topic];
    if (exist != null) return exist;

    final channel = _client.channel(
      topic,
      opts: RealtimeChannelConfig(self: includeSelfInState),
    );
    channel
      ..onPresenceSync((_) {
        final ids = channel
            .presenceState()
            .map(
              (state) => state.presences
                  .map((presence) => presence.payload[_kPresenceUserIdKey])
                  .where((id) => (id is String && id.isNotEmpty))
                  .map((id) => id as String),
            )
            .flatten;
        _onlineIds[topic] = ids.toSet();
        _controllers[topic]?.add(Set.unmodifiable(ids));
      })
      ..onPresenceJoin((payload) {
        final joinIds = payload.newPresences
            .map((newPresence) => newPresence.payload[_kPresenceUserIdKey])
            .where((id) => (id is String && id.isNotEmpty))
            .map((id) => id as String);

        _controllers[topic]?.add(Set.unmodifiable(joinIds));
      })
      ..onPresenceLeave((payload) {
        final leaveIds = payload.leftPresences
            .map((leftPresence) => leftPresence.payload[_kPresenceUserIdKey])
            .where((id) => (id is String && id.isNotEmpty))
            .map((id) => id as String);
        final remainIds = _onlineIds[topic] ??= <String>{};
        remainIds.removeAll(leaveIds);

        _controllers[topic]?.add(Set.unmodifiable(remainIds));
      });

    _channels[topic] = channel;
    _onlineIds.putIfAbsent(topic, () => <String>{});
    return channel;
  }

  StreamController<Set<String>> _ensureController(String topic) {
    final exist = _controllers[topic];
    if (exist != null && !exist.isClosed) return exist;

    final ctrl = StreamController<Set<String>>.broadcast();
    _controllers[topic] = StreamController<Set<String>>.broadcast();
    return ctrl;
  }
}
