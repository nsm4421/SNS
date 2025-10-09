import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/repository/repository.export.dart';

part 'scenario/sign_up.usecase.dart';

part 'scenario/sign_in.usecase.dart';

part 'scenario/sign_out.usecase.dart';

part 'scenario/restore_session.usecase.dart';

part 'scenario/get_current_user.usecase.dart';

@lazySingleton
class AuthUseCases {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthUseCases(this._authRepository, this._userRepository);

  Stream<AppUserEntity?> get authStream => _authRepository.authStream;

  SignUpUseCase get signUp => SignUpUseCase(_authRepository, _userRepository);

  SignInUseCase get signIn => SignInUseCase(_authRepository, _userRepository);

  SignOutUseCase get signOut => SignOutUseCase(_authRepository);

  RestoreSessionUseCase get restoreSession =>
      RestoreSessionUseCase(_authRepository);

  GetCurrentUserUseCase get getCurrentUser =>
      GetCurrentUserUseCase(_authRepository);
}
