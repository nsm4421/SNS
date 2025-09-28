import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/vo/failure.vo.dart';
import 'package:karma/domain/entity/auth/user.entity.dart';
import 'package:karma/domain/usecase/auth/auth.usecases.dart';

part 'auth.state.dart';

part 'auth.event.dart';

part 'auth.bloc.freezed.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCases _useCases;

  AuthBloc(this._useCases) : super(const AuthState.initial()) {
    on<_Started>(_onStarted);
    on<_SignInRequested>(_onSignInRequested);
    on<_SignUpRequested>(_onSignUpRequested);
    on<_SignOutRequested>(_onSignOutRequested);
  }

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
    emit(const AuthState.loading());
    await _useCases.signIn
        .call(email: event.email, password: event.password)
        .then(
          (res) => res.match(
            (l) => emit(AuthState.failure(l)),
            (r) => emit(AuthState.authenticated(r)),
          ),
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
            (l) => emit(AuthState.failure(l)),
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
