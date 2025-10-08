part of 'online_users_presence.bloc.dart';

@freezed
class OnlineUsersPresenceEvent with _$OnlineUsersPresenceEvent {
  const factory OnlineUsersPresenceEvent.started() = _Started;

  const factory OnlineUsersPresenceEvent.refreshed() = _Refreshed;

  const factory OnlineUsersPresenceEvent.userIdsChanged(Set<String> userIds) =
      _UserIdsChanged;

  const factory OnlineUsersPresenceEvent.stopped() = _Stopped;
}
