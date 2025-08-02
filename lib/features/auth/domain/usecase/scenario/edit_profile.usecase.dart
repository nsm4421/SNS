part of '../auth.usecases.dart';

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
