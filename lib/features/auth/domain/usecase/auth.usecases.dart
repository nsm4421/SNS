import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/auth_state.constant.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';
import 'scenario/restore_session.usecase.dart';
import 'scenario/sign_in.usecase.dart';
import 'scenario/sign_out.usecase.dart';
import 'scenario/sign_up.usecase.dart';

@lazySingleton
class AuthUseCases {
  final AuthRepository _repository;

  AuthUseCases(this._repository);

  Stream<AuthStatus> get authStatusStream => _repository.authStatusStream;

  SignInUseCase get signIn => SignInUseCase(_repository);

  SignUpUseCase get signUp => SignUpUseCase(_repository);

  SignOutUseCase get signOut => SignOutUseCase(_repository);

  RestoreSessionUseCase get restoreSession =>
      RestoreSessionUseCase(_repository);
}
