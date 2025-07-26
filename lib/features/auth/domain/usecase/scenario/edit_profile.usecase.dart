import 'package:sns/core/constant/user_profile.constant.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';

class EditProfileUseCase {
  final AuthRepository _repository;

  EditProfileUseCase(this._repository);

  Future<void> call({String? username, Sex? sex, String? description}) async {
    return await _repository.editProfile(
      username: username,
      sex: sex,
      description: description,
    );
  }
}
