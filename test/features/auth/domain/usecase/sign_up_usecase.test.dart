import 'package:flutter_test/flutter_test.dart';
import 'package:sns/features/auth/domain/usecase/sign_up.usecase.dart';

import '../../data/repository/mock_auth.repository.dart';

void main() {
  group('회원가입 유즈케이스', () {
    late SignUpUseCase signUpUseCase;
    const email = 'nsm4421@naver.com';
    const password = '951221';
    const username = 'karma';

    setUp(() {
      signUpUseCase = SignUpUseCase(MockAuthRepositoryImpl());
    });

    test('회원가입 성공 시, 토큰 반환', () async {
      final res = await signUpUseCase.call(
        email: email,
        password: password,
        username: username,
      );
      expect(res, 'token');
    });

    test('이메일이 올바르지 않은 경우 오류', () async {
      expect(
        () async => await signUpUseCase.call(
          email: '',
          password: password,
          username: username,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('비밀번호가 너무 짧은 경우 오류', () async {
      expect(
        () async => await signUpUseCase.call(
          email: email,
          password: '123',
          username: username,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
