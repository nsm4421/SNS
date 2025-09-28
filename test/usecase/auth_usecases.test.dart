import 'package:fpdart/fpdart.dart';
import 'package:karma/core/vo/error_message.vo.dart';
import 'package:karma/domain/usecase/auth/auth.usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';
import 'package:test/test.dart';

import 'package:karma/core/vo/failure.vo.dart';
import 'package:karma/domain/entity/auth/user.entity.dart';
import 'package:karma/domain/repository/auth.repository.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repo;
  setUp(() {
    repo = _MockAuthRepository();
  });

  const email = 'test@naver.com';
  const password = '951221';
  const username = 'test_username';
  final user = AppUserEntity(id: 'u1', email: email);

  group('SignUpUseCase', () {
    late SignUpUseCase usecase;
    setUp(() {
      usecase = SignUpUseCase(repo);
    });

    test('회원가입 성공시 AppUserEntity를 반환함', () async {
      when(
        () => repo.signUp(
          email: email,
          password: password,
          username: any(named: 'username'),
          avatarUrl: any(named: 'avatarUrl'),
        ),
      ).thenAnswer((_) async => Right<Failure, AppUserEntity>(user));

      final signUpSuccess = await usecase(
        email: email,
        password: password,
        username: username,
      );
      final signUpUser = signUpSuccess.getRight().toNullable()!;
      expect(signUpSuccess.isRight(), isTrue);
      expect(signUpUser, user);
      expect(signUpUser.email, email);
      verify(
        () => repo.signUp(
          email: email,
          password: password,
          username: any(named: 'username'),
          avatarUrl: any(named: 'avatarUrl'),
        ),
      ).called(1);
    });

    test("이메일이 중복된 경우 'duplicated email'라는 에러메세지", () async {
      when(
        () => repo.signUp(
          email: email,
          password: password,
          username: any(named: 'username'),
          avatarUrl: any(named: 'avatarUrl'),
        ),
      ).thenAnswer(
        (_) async => const Left<Failure, AppUserEntity>(
          Failure('error', code: ErrorCode.conflict),
        ),
      );

      final signUpFailure = await usecase(
        email: email,
        password: password,
        username: username,
      );
      final failure = signUpFailure.getLeft().toNullable();
      expect(signUpFailure.isLeft(), isTrue);
      expect(failure, isNotNull);
      expect(failure?.message, AuthErrorMessage.duplicatedEmail.message);
      verify(
        () => repo.signUp(
          email: email,
          password: password,
          username: any(named: 'username'),
          avatarUrl: any(named: 'avatarUrl'),
        ),
      ).called(1);
    });
  });

  group('SignInUseCase', () {
    late SignInUseCase usecase;
    setUp(() {
      usecase = SignInUseCase(repo);
    });

    test('로그인 성공시 AppUserEntity를 반환함', () async {
      when(
        () => repo.signIn(email: email, password: password),
      ).thenAnswer((_) async => Right<Failure, AppUserEntity>(user));

      final signInSuccess = await usecase(email: email, password: password);
      final signUpUser = signInSuccess.getRight().toNullable();
      expect(signInSuccess.isRight(), isTrue);
      expect(signUpUser, user);
      expect(signUpUser?.email, email);

      verify(() => repo.signIn(email: email, password: password)).called(1);
    });

    test("잘못된 이메일이나 비밀번호 입력시 'invalid credentials'라는 에러메세지", () async {
      when(() => repo.signIn(email: email, password: password)).thenAnswer(
        (_) async => const Left<Failure, AppUserEntity>(
          Failure('error', code: ErrorCode.invalidCredential),
        ),
      );

      final signInFailure = await usecase(email: email, password: password);
      final failure = signInFailure.getLeft().toNullable();
      expect(signInFailure.isLeft(), isTrue);
      expect(failure, isNotNull);
      expect(failure?.message, AuthErrorMessage.invalidCredentials.message);
      verify(() => repo.signIn(email: email, password: password)).called(1);
    });
  });
}
