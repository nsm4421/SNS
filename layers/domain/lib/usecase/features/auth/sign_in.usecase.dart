import 'package:domain/repository/features/auth/auth.repository.dart';
import 'package:either_dart/either.dart';
import 'package:shared/exception/api/api_error_type.dart';
import 'package:shared/exception/failure/failure.dart';

class SignInUseCase {
  final AuthRepository _repository;

  const SignInUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
  }) async {
    final signInRes = await _repository.signInAndReturnTokens(
      email: email,
      password: password,
    );
    if (signInRes.isLeft) {
      final message = switch (signInRes.left.type) {
        ApiErrorType.validation => '이메일이나 비밀번호가 유효하지 않습니다',
        ApiErrorType.notFound => '존재하지 않는 이메일입니다',
        (_) => '로그인 중 오류가 발생했습니다',
      };
      return Left(Failure(message));
    }

    final saveTokenRes = await _repository.saveTokensInLocalStorage(
      accessToken: signInRes.right.$1,
      refreshToken: signInRes.right.$2,
    );
    if (saveTokenRes.isLeft) {
      return Left(Failure('로그인 중 오류가 발생했습니다'));
    }

    return const Right(null);
  }
}
