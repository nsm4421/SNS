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
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
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
    emit(const AuthenticationState.checking());
    await authUseCases.restoreSession();
  }

  Future<void> _onSignIn(
    SignInEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(const AuthenticationState.checking());
      await authUseCases.signIn(email: event.email, password: event.password);
    } catch (e) {
      emit(AuthenticationState.failure(e.toString()));
    }
  }

  Future<void> _onSignUp(
    SignUpEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(const AuthenticationState.checking());
      await authUseCases.signUp(
        email: event.email,
        password: event.password,
        username: event.username,
      );
    } catch (e) {
      emit(AuthenticationState.failure(e.toString()));
    }
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    await authUseCases.signOut();
  }
}
