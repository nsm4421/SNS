import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/response_wrapper/api_response/api_error_type.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/core/extension/logger.extension.dart';
import 'package:sns/domain/repository/auth.repository.dart';

class SignInUseCase {
  final AuthRepository _repository;
  final Logger? logger;

  const SignInUseCase(this._repository, {this.logger});

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
      logger?.logApiError(signInRes.left);
      return Left(Failure(message));
    }

    final saveTokenRes = await _repository.saveTokensInLocalStorage(
      accessToken: signInRes.right.$1,
      refreshToken: signInRes.right.$2,
    );
    if (saveTokenRes.isLeft) {
      logger?.logApiError(saveTokenRes.left);
      return Left(Failure('로그인 중 오류가 발생했습니다'));
    }

    return const Right(null);
  }
}
