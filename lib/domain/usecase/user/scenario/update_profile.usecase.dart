part of '../user.usecases.dart';

final class UpdateProfileUseCase {
  final UserRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    required String userId,
    required String username,
    // TODO : username 필드 외 다른 필드 업데이트
    // String? displayName,
    // String? avatarUrl,
    // String? bio,
    // String? statusMessage,
  }) async {
    return await _repository.updateProfile(userId: userId, username: username);
  }
}
