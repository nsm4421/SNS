import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/logger/app_logger.dart';
import 'package:sns/domain/repository/auth.repository.dart';
import 'package:sns/domain/repository/user.repository.dart';
import 'package:sns/domain/usecase/screnario/auth/find_by_uid.usecase.dart';
import 'package:sns/domain/usecase/screnario/auth/get_current_user.usecase.dart';
import 'package:sns/domain/usecase/screnario/auth/restore_session.usecase.dart';
import 'package:sns/domain/usecase/screnario/auth/sign_in.usecase.dart';
import 'package:sns/domain/usecase/screnario/auth/sign_out.usecase.dart';
import 'package:sns/domain/usecase/screnario/auth/sign_up.usecase.dart';

@lazySingleton
class AuthUseCases with AppLogger {
  AuthUseCases({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _userRepository = userRepository;

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  Stream<AuthStatus> get authStatusStream => _authRepository.authStatusStream;

  FindUserByUidUseCase get findUserById =>
      FindUserByUidUseCase(_userRepository, logger: logger);

  GetCurrentUserUseCase get getCurrentUser =>
      GetCurrentUserUseCase(_authRepository, logger: logger);

  SignInUseCase get signIn => SignInUseCase(_authRepository, logger: logger);

  SignUpUseCase get signUp => SignUpUseCase(_authRepository, logger: logger);

  SignOutUseCase get signOut => SignOutUseCase(_authRepository, logger: logger);

  RestoreSessionUseCase get restoreSession =>
      RestoreSessionUseCase(_authRepository, logger: logger);
}
