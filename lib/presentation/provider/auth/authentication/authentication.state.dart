part of 'authentication.bloc.dart';

class AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthenticationState._({required this.status, this.errorMessage});

  const AuthenticationState.checking() : this._(status: AuthStatus.checking);

  const AuthenticationState.authenticated()
      : this._(status: AuthStatus.authenticated);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  const AuthenticationState.failure(String message)
      : this._(status: AuthStatus.unauthenticated, errorMessage: message);
}
