import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/auth_state.constant.dart';
import 'package:sns/features/auth/domain/usecase/auth.usecases.dart';

part 'authentication.state.dart';

part 'authentication.event.dart';

@lazySingleton
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthUseCases authUseCases;

  AuthenticationBloc(this.authUseCases)
    : super(const AuthenticationState.checking()) {
    on<AppStartedEvent>(_onAppStarted);
    on<SignOutEvent>(_onSignOut);

    authUseCases.authStatusStream.listen((status) {
      add(_mapStatusToEvent(status));
    });
  }

  AuthenticationEvent _mapStatusToEvent(AuthStatus status) {
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
      await authUseCases.restoreSession();
    } catch (error) {
      log(error.toString());
      emit(const AuthenticationState.failure('auth fail on starting app'));
    }
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await authUseCases.signOut();
    } catch (error) {
      log(error.toString());
      emit(const AuthenticationState.failure('sign out fails'));
    }
  }
}
