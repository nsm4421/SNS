import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/domain/entity/auth/user.entity.dart';
import 'package:karma/domain/usecase/usecase.export.dart';

part 'online_users_presence.state.dart';

part 'online_users_presence.event.dart';

part 'online_users_presence.bloc.freezed.dart';

@injectable
class OnlineUsersPresenceBloc
    extends Bloc<OnlineUsersPresenceEvent, OnlineUsersPresenceState> {
  final String _topic;
  final UserUseCases _useCases;

  OnlineUsersPresenceBloc(
    @factoryParam this._topic, {
    required UserUseCases userUseCases,
  }) : _useCases = userUseCases,
       super(const OnlineUsersPresenceState.initial()) {
    on<_Started>(_onStarted);
    on<_Refreshed>(_onRefreshed);
    on<_UserIdsChanged>(_onUserIdsChanged, transformer: restartable());
    on<_Stopped>(_onStopped);
  }

  final Map<String, UserEntity> _userCache = {};
  late final StreamSubscription<Set<String>> _userIdsSubscription;

  Future<void> _onStarted(
    _Started e,
    Emitter<OnlineUsersPresenceState> emit,
  ) async {
    emit(const OnlineUsersPresenceState.loading());
    try {
      await _userIdsSubscription.cancel();
      _userIdsSubscription = _useCases
          .getOnlineUserIdsStream(_topic)
          .where((ids) => !_isEqualSet(ids, _userCache.keys.toSet()))
          .listen((ids) {
            add(OnlineUsersPresenceEvent.userIdsChanged(ids));
          });
      await _useCases.startOnlinePresence(_topic);
    } catch (err) {
      emit(OnlineUsersPresenceState.failure('$err'));
    }
  }

  Future<void> _onUserIdsChanged(
    _UserIdsChanged e,
    Emitter<OnlineUsersPresenceState> emit,
  ) async {
    emit(const OnlineUsersPresenceState.loading());
    try {
      final incomingUserIds = e._userIds;
      final cachedUserIds = _userCache.keys.toSet();

      final userIdsToRemove = cachedUserIds.difference(incomingUserIds);
      for (final id in userIdsToRemove) {
        _userCache.remove(id);
      }

      final userIdsToFetch = incomingUserIds.difference(cachedUserIds);
      if (userIdsToFetch.isEmpty) return;
      final futures = userIdsToFetch.map(
        (id) async => await _useCases
            .getById(id)
            .then((res) => res.match((failure) => null, (user) => user)),
      );
      final fetchedUsers = (await Future.wait(
        futures,
      )).where((e) => e != null).map((e) => e!);
      for (final user in fetchedUsers) {
        _userCache[user.id] = user;
      }

      emit(OnlineUsersPresenceState.loaded(users: _userCache.values.toList()));
    } catch (err) {
      emit(OnlineUsersPresenceState.failure('$err'));
    }
  }

  Future<void> _onRefreshed(
    _Refreshed e,
    Emitter<OnlineUsersPresenceState> emit,
  ) async {
    emit(const OnlineUsersPresenceState.loading());
    try {
      if (_userCache.isEmpty) {
        emit(const OnlineUsersPresenceState.loaded(users: []));
        return;
      }

      final futures = _userCache.keys.map(
        (id) async => await _useCases
            .getById(id)
            .then((res) => res.match((failure) => null, (r) => r)),
      );
      final fetchedUsers = (await Future.wait(
        futures,
      )).where((e) => e != null).map((e) => e!);
      for (final user in fetchedUsers) {
        _userCache[user.id] = user;
      }
      emit(OnlineUsersPresenceState.loaded(users: _userCache.values.toList()));
    } catch (err) {
      emit(OnlineUsersPresenceState.failure('$err'));
    }
  }

  Future<void> _onStopped(
    _Stopped e,
    Emitter<OnlineUsersPresenceState> emit,
  ) async {
    emit(const OnlineUsersPresenceState.loading());
    try {
      await _userIdsSubscription.cancel();
      _userCache.clear();
      emit(const OnlineUsersPresenceState.initial());
    } catch (err) {
      emit(OnlineUsersPresenceState.failure('$err'));
    }
  }

  @override
  Future<void> close() async {
    await _userIdsSubscription.cancel();
    return super.close();
  }

  bool _isEqualSet(Set<String> a, Set<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    final small = a.length <= b.length ? a : b;
    final big = identical(small, a) ? b : a;
    for (final v in small) {
      if (!big.contains(v)) return false;
    }
    return true;
  }
}
