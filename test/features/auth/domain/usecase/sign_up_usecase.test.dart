import 'package:flutter_test/flutter_test.dart';
import 'package:sns/core/dependency_injection/dependency_injection.dart';
import 'package:sns/core/env/env.dart';
import 'package:sns/core/response/failure.dart';
import 'package:sns/features/auth/domain/usecase/auth.usecases.dart';
import 'package:sns/features/auth/domain/usecase/scenario/sign_up.usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
    configureDependencies();
  });

  group('회원가입 유즈케이스', () {
    const email = 'nsm4421@naver.com';
    const password = '951221';
    const username = 'karma';
    late SignUpUseCase signUpUseCase;
    setUp(() {
      signUpUseCase = getIt<AuthUseCases>().signUp;
    });

    test('이메일이 올바르지 않은 경우 오류', () async {
      final res = await signUpUseCase.call(
        email: '',
        password: password,
        username: username,
      );
      expect(res.isLeft, isTrue);
      expect(res.left, isA<Failure>());
    });

    test('비밀번호가 너무 짧은 경우 오류', () async {
      final res = await signUpUseCase.call(
        email: email,
        password: '123',
        username: username,
      );
      expect(res.isLeft, isTrue);
      expect(res.left, isA<Failure>());
    });
  });
}
