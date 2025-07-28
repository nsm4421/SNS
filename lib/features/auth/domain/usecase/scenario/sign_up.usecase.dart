import 'package:either_dart/either.dart';
import 'package:sns/core/response/api_error.dart';
import 'package:sns/core/response/api_error_to_failure_mapper_mixin.dart';
import 'package:sns/core/response/failure.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';

class SignUpUseCase with ApiErrorToFailureMapperMixIn {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
    required String username,
  }) async {
    return await _repository
        .signUp(email: email, password: password, username: username)
        .thenLeft((l) {
          return Left(() {
            switch (l.type) {
              case ApiErrorType.validation:
                if (l.message.contains('password')) {
                  return Failure.validation('password is too week');
                }
                if (l.message.contains('email')) {
                  return Failure.validation('email is invalid');
                }
                return handleFailure(l);
              case ApiErrorType.conflict:
                return Failure.duplicated('email is duplicated');
              default:
                return handleFailure(l);
            }
          }());
        });
  }
}
