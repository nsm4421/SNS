import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/auth_state.constant.dart';
import 'package:sns/core/util/logger/sington_logger.util.dart';
import 'package:sns/features/auth/domain/usecase/auth.usecases.dart';

part 'authentication.state.dart';

part 'authentication.event.dart';

@lazySingleton
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>
    with AppLogger {
  final AuthUseCases _authUseCases;

  AuthenticationBloc(this._authUseCases)
    : super(const AuthenticationState.checking()) {
    on<AppStartedEvent>(_onAppStarted);
    on<_AuthenticatedEvent>(_onAuth);
    on<_UnAuthenticatedEvent>(_onUnAuth);
    on<SignOutEvent>(_onSignOut);
    _authUseCases.authStatusStream.listen((status) {
      add(_mapStatusToEvent(status));
    });
  }

  AuthenticationEvent _mapStatusToEvent(AuthStatus status) {
    logger.t('[AuthenticationBloc]auth status changed : $status');
    switch (status) {
      case AuthStatus.authenticated:
        return _AuthenticatedEvent();
      case AuthStatus.unauthenticated:
        return _UnAuthenticatedEvent();
      case AuthStatus.checking:
        return AppStartedEvent();
    }
  }

  Future<void> _onAppStarted(
    AppStartedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(const AuthenticationState.checking());
      await _authUseCases.restoreSession().then(
        (res) => res.fold(
          (l) {
            logger.e(l);
            emit(const AuthenticationState.unauthenticated());
          },
          (r) {
            emit(const AuthenticationState.authenticated());
          },
        ),
      );
    } catch (error) {
      logger.e(error);
      emit(const AuthenticationState.failure('auth fail on starting app'));
    }
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await _authUseCases.signOut().then(
        (res) => res.fold(
          (l) {
            logger.e(l);
            emit(const AuthenticationState.unauthenticated());
          },
          (r) {
            emit(const AuthenticationState.unauthenticated());
          },
        ),
      );
    } catch (error) {
      logger.e(error);
      emit(const AuthenticationState.failure('sign out fails'));
    }
  }

  Future<void> _onAuth(
    _AuthenticatedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(const AuthenticationState.authenticated());
    } catch (error) {
      logger.e(error);
      emit(const AuthenticationState.failure('authentication failure'));
    }
  }

  Future<void> _onUnAuth(
    _UnAuthenticatedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(const AuthenticationState.unauthenticated());
    } catch (error) {
      logger.e(error);
      emit(const AuthenticationState.failure('authentication failure'));
    }
  }
}
