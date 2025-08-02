import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/auth/domain/entity/user.entity.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';

part 'scenario/edit_profile.usecase.dart';

part 'scenario/find_user_by_uid.usecase.dart';

part 'scenario/get_current_user.usecase.dart';

part 'scenario/restore_session.usecase.dart';

part 'scenario/sign_in.usecase.dart';

part 'scenario/sign_out.usecase.dart';

part 'scenario/sign_up.usecase.dart';

@lazySingleton
class AuthUseCases {
  final AuthRepository _repository;

  AuthUseCases(this._repository);

  Stream<AuthStatus> get authStatusStream => _repository.authStatusStream;

  Future<bool> get getIsAuth => _repository.getIsAuth();

  SignInUseCase get signIn => SignInUseCase(_repository);

  SignUpUseCase get signUp => SignUpUseCase(_repository);

  SignOutUseCase get signOut => SignOutUseCase(_repository);

  RestoreSessionUseCase get restoreSession =>
      RestoreSessionUseCase(_repository);

  GetCurrentUserUseCase get getCurrentUser =>
      GetCurrentUserUseCase(_repository);

  FindUserByUidUseCase get findByUid => FindUserByUidUseCase(_repository);

  EditProfileUseCase get editProfile => EditProfileUseCase(_repository);
}
