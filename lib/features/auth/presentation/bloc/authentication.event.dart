part of 'authentication.bloc.dart';

sealed class AuthenticationEvent {}

class AppStartedEvent extends AuthenticationEvent {}

class SignInEvent extends AuthenticationEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthenticationEvent {
  final String email;
  final String password;
  final String username;

  SignUpEvent({
    required this.email,
    required this.password,
    required this.username,
  });
}

class SignOutEvent extends AuthenticationEvent {}

class _AuthenticatedEvent extends AuthenticationEvent {}

class _UnAuthenticatedEvent extends AuthenticationEvent {}

