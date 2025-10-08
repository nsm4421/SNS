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
  final AuthRepository _repository;

  AuthUseCases(this._repository);

  Stream<AppUserEntity?> get authStream => _repository.authStream;

  SignUpUseCase get signUp => SignUpUseCase(_repository);

  SignInUseCase get signIn => SignInUseCase(_repository);

  SignOutUseCase get signOut => SignOutUseCase(_repository);

  RestoreSessionUseCase get restoreSession =>
      RestoreSessionUseCase(_repository);

  GetCurrentUserUseCase get getCurrentUser =>
      GetCurrentUserUseCase(_repository);
}
