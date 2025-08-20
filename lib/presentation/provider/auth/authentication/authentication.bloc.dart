import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/domain/usecase/auth_usecases.dart';

part 'authentication.state.dart';

part 'authentication.event.dart';

@lazySingleton
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthUseCases _authUseCase;

  AuthenticationBloc(this._authUseCase)
    : super(const AuthenticationState.checking()) {
    on<AppStartedEvent>(_onAppStarted);
    on<_AuthenticatedEvent>(_onAuth);
    on<_UnAuthenticatedEvent>(_onUnAuth);
    on<SignOutEvent>(_onSignOut);
    _authUseCase.authStatusStream.listen((status) {
      add(switch (status) {
        AuthStatus.authenticated => _AuthenticatedEvent(),
        AuthStatus.unauthenticated => _UnAuthenticatedEvent(),
        AuthStatus.checking => AppStartedEvent(),
      });
    });
  }

  Stream<AuthStatus> get authStatusStream => _authUseCase.authStatusStream;

  Future<void> _onAppStarted(
    AppStartedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(const AuthenticationState.checking());
      await _authUseCase.restoreSession().then(
        (res) => res.fold(
          (l) {
            emit(const AuthenticationState.unauthenticated());
          },
          (r) {
            emit(const AuthenticationState.authenticated());
          },
        ),
      );
    } catch (error) {
      emit(const AuthenticationState.failure('로그인이 필요합니다'));
    }
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await _authUseCase.signOut();
    } finally {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  Future<void> _onAuth(
    _AuthenticatedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(const AuthenticationState.authenticated());
    } catch (error) {
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
      emit(const AuthenticationState.failure('authentication failure'));
    }
  }
}
