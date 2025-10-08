import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/usecase/usecase.export.dart';

part 'auth.state.dart';

part 'auth.event.dart';

part 'auth.bloc.freezed.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCases _useCases;
  AppUserEntity? _currentUser;
  late final StreamSubscription<AppUserEntity?> _streamSubscription;

  AuthBloc(this._useCases) : super(const AuthState.initial()) {
    on<_Started>(_onStarted);
    on<_SignInRequested>(_onSignInRequested);
    on<_SignUpRequested>(_onSignUpRequested);
    on<_SignOutRequested>(_onSignOutRequested);
    on<_AuthChanged>(_onAuthChanged);
    _streamSubscription = _useCases.authStream
        .distinct((prev, curr) => prev?.id == curr?.id)
        .listen((u) {
          _currentUser = u;
          add(AuthEvent.authChanged(u));
        });
  }

  AppUserEntity? get currentUser => _currentUser;

  Future<void> _onStarted(_Started event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    await _useCases.restoreSession.call().then((res) {
      return res.match(
        (l) => emit(const AuthState.unauthenticated()),
        (r) => emit(AuthState.authenticated(r)),
      );
    });
  }

  Future<void> _onSignInRequested(
    _SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    await _useCases.signIn
        .call(email: event.email, password: event.password)
        .then(
          (res) => res.match((l) {
            appLogger.logF(l);
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
          (res) => res.match((l) {
            appLogger.logF(l);
            emit(AuthState.failure(l));
          }, (r) => emit(AuthState.authenticated(r))),
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

  Future<void> _onAuthChanged(
    _AuthChanged event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      event.user == null
          ? const AuthState.unauthenticated()
          : AuthState.authenticated(event.user!),
    );
  }

  @override
  Future<void> close() async {
    await _streamSubscription.cancel();
    return super.close();
  }
}
