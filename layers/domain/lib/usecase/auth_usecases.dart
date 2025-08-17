import 'package:domain/usecase/features/auth/find_user_by_id.usecase.dart';
import 'package:domain/usecase/features/auth/get_current_user.usecase.dart';
import 'package:domain/usecase/features/auth/restore_session.usecase.dart';
import 'package:domain/usecase/features/auth/sign_in.usecase.dart';
import 'package:domain/usecase/features/auth/sign_out.usecase.dart';
import 'package:domain/usecase/features/auth/sign_up.usecase.dart';
import 'package:domain/domain.dart';
import 'package:shared/constant/status.constant.dart';

class AuthUseCases {
  AuthUseCases({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _userRepository = userRepository;

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  Stream<AuthStatus> get authStatusStream => _authRepository.authStatusStream;

  FindUserByUidUseCase get findUserById =>
      FindUserByUidUseCase(_userRepository);

  GetCurrentUserUseCase get getCurrentUser =>
      GetCurrentUserUseCase(_authRepository);

  SignInUseCase get signIn => SignInUseCase(_authRepository);

  SignUpUseCase get signUp => SignUpUseCase(_authRepository);

  SignOutUseCase get signOut => SignOutUseCase(_authRepository);

  RestoreSessionUseCase get restoreSession =>
      RestoreSessionUseCase(_authRepository);
}
