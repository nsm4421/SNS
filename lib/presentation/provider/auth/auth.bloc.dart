import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/domain/entity/auth/user.entity.dart';
import 'package:karma/domain/usecase/auth/auth.usecases.dart';
import 'package:shared/shared.dart';

part 'auth.state.dart';

part 'auth.event.dart';

part 'auth.bloc.freezed.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> with LoggerUtilMixIn {
  final AuthUseCases _useCases;
  AppUserEntity? _currentUser;

  AuthBloc(this._useCases) : super(const AuthState.initial()) {
    on<_Started>(_onStarted);
    on<_SignInRequested>(_onSignInRequested);
    on<_SignUpRequested>(_onSignUpRequested);
    on<_SignOutRequested>(_onSignOutRequested);
    _useCases.authStream.listen((u) {
      _currentUser = u;
    });
  }

  AppUserEntity? get currentUser => _currentUser;

  @lazySingleton
  Stream<AppUserEntity?> get authStream => _useCases.authStream;

  Future<void> _onStarted(_Started event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    await _useCases.restoreSession.call().then(
      (res) => res.match(
        (l) => emit(const AuthState.unauthenticated()),
        (r) => emit(AuthState.authenticated(r)),
      ),
    );
  }

  Future<void> _onSignInRequested(
    _SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    logger.t('_onSignInRequested email:${event.email}');
    emit(const AuthState.loading());
    await _useCases.signIn
        .call(email: event.email, password: event.password)
        .then(
          (res) => res.match((l) {
            logger.fail(l);
            emit(AuthState.failure(l));
          }, (r) => emit(AuthState.authenticated(r))),
        );
  }

  Future<void> _onSignUpRequested(
    _SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    await _useCases.signUp
        .call(
          email: event.email,
          password: event.password,
          username: event.username,
          avatarUrl: event.avatarUrl,
        )
        .then(
          (res) => res.match(
            (l)  {
              logger.fail(l);
              emit(AuthState.failure(l));
            },
            (r) => emit(AuthState.authenticated(r)),
          ),
        );
  }

  Future<void> _onSignOutRequested(
    _SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    await _useCases.signOut.call().then((_) {
      emit(const AuthState.unauthenticated());
    });
  }
}
