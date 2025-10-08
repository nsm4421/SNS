part of 'online_users_presence.bloc.dart';

@freezed
class OnlineUsersPresenceState with _$OnlineUsersPresenceState {
  const factory OnlineUsersPresenceState.initial() = _Initial;

  const factory OnlineUsersPresenceState.loading() = _Loading;

  /// 현재 온라인 유저들
  const factory OnlineUsersPresenceState.loaded({
    required List<UserEntity> users,
  }) = _Loaded;

  const factory OnlineUsersPresenceState.failure(String message) = _Failure;
}
