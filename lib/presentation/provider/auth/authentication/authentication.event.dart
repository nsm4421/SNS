part of 'authentication.bloc.dart';

sealed class AuthenticationEvent {}

class AppStartedEvent extends AuthenticationEvent {}

class SignOutEvent extends AuthenticationEvent {}

class _AuthenticatedEvent extends AuthenticationEvent {}

class _UnAuthenticatedEvent extends AuthenticationEvent {}
