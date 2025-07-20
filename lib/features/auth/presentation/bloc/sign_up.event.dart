part of 'sign_up.bloc.dart';

abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String password;
  final String username;

  SignUpSubmitted({
    required this.email,
    required this.password,
    required this.username,
  });
}
