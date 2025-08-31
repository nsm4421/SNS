import 'package:injectable/injectable.dart';
import 'package:shared/constant/auth_status.constant.dart';
import 'package:sns/domain/repository/auth.repository.dart';
import 'package:sns/domain/repository/user.repository.dart';
import 'package:sns/domain/usecase/screnario/auth/find_by_uid.usecase.dart';
import 'package:sns/domain/usecase/screnario/auth/get_current_user.usecase.dart';
import 'package:sns/domain/usecase/screnario/auth/restore_session.usecase.dart';
import 'package:sns/domain/usecase/screnario/auth/sign_in.usecase.dart';
import 'package:sns/domain/usecase/screnario/auth/sign_out.usecase.dart';
import 'package:sns/domain/usecase/screnario/auth/sign_up.usecase.dart';

@lazySingleton
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
