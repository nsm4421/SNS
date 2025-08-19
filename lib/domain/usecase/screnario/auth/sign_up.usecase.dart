import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:response_wrapper/response_wrapper.dart';
import 'package:sns/domain/repository/auth.repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  const SignUpUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
    required String username,
    File? profileImage,
  }) async {
    // TODO : 이미지 파일 업로드
    String? profileImageUrl;

    final signUpRes = await _repository.signUpAndReturnTokens(
      email: email,
      password: password,
      username: username,
      profileImage: profileImageUrl,
    );
    if (signUpRes.isLeft) {
      final message = switch (signUpRes.left.type) {
        ApiErrorType.validation => '이메일이나 비밀번호가 유효하지 않습니다',
        ApiErrorType.conflict => '이메일이나 유저명이 중복되었습니다',
        (_) => '회원가입 도중 오류가 발생했습니다',
      };
      return Left(Failure(message));
    }

    await _repository.saveTokensInLocalStorage(
      accessToken: signUpRes.right.$1,
      refreshToken: signUpRes.right.$2,
    );

    // 토큰 저장 성공여부와 관계없이 회원가입 성공시 성공으로 처리
    return const Right(null);
  }
}
