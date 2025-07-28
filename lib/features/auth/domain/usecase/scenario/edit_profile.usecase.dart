import 'package:either_dart/either.dart';
import 'package:sns/core/constant/user_profile.constant.dart';
import 'package:sns/core/response/api_error.dart';
import 'package:sns/core/response/api_error_to_failure_mapper_mixin.dart';
import 'package:sns/core/response/failure.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';

class EditProfileUseCase with ApiErrorToFailureMapperMixIn {
  final AuthRepository _repository;

  EditProfileUseCase(this._repository);

  Future<Either<Failure, void>> call({
    String? username,
    Sex? sex,
    String? description,
  }) async {
    return await _repository
        .editProfile(username: username, sex: sex, description: description)
        .thenLeft((l) {
          return Left(() {
            switch (l.type) {
              case ApiErrorType.validation:
                return Failure.validation('validation fails');
              case ApiErrorType.conflict:
                return Failure.duplicated('username is already in use');
              default:
                return handleFailure(l);
            }
          }());
        });
  }
}
