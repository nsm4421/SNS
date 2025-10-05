import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/auth/remote/auth_datasource.dart';
import 'package:supabase_datasource/src/auth/remote/dto/sign_in.dto.dart';
import 'package:supabase_datasource/src/auth/remote/dto/sign_up.dto.dart';
import 'package:supabase_datasource/src/models/auth/app_user.model.dart';
import 'package:test/test.dart';

import '../fixtures.dart';
import '../mocks.dart';

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockSupabaseAuth;
  late AuthDataSource datasource;
  late String email;
  late String password;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockSupabaseAuth = MockGoTrueClient();
    email = 'nsm4421@naver.com';
    password = '951221';

    when(() => mockSupabaseClient.auth).thenReturn(mockSupabaseAuth);

    datasource = SupabaseAuthDataSourceImpl(mockSupabaseAuth);
  });

  group('회원가입', () {
    test('회원가입이 정상적으로 이루어지는 경우, AppUserModel을 반환함', () async {
      final supabaseUser = User.fromJson(mockUserJson());
      final session = Session.fromJson(mockSessionJson());

      when(
        () => mockSupabaseAuth.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => AuthResponse(user: supabaseUser, session: session),
      );

      expect(
        datasource.signUp(
          SignUpRequestDto(email: email, password: password),
        ),
        isA<Future<SignUpResponseDto>>(),
      );

      verify(
        () => mockSupabaseAuth.signUp(
          email: email,
          password: password,
          data: any(named: 'data'),
        ),
      ).called(1);
    });

    test(
      "이미 가입된 이메일이면, 에러코드는 CONFLICT, 에러메세지 email already registered",
      () async {
        when(
          () => mockSupabaseAuth.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          const AuthException(
            'User already registered',
            statusCode: '400',
          ),
        );

        requestCallback() async => await datasource.signUp(
          SignUpRequestDto(email: email, password: password),
        );

        expect(
          requestCallback,
          throwsA(isA<CustomException>()),
        );

        try {
          await requestCallback();
          fail('회원가입 실패해야 하는데 성공함');
        } on CustomException catch (e) {
          expect(e.code, ErrorCode.conflict);
          expect(e.message, 'email already registered');
        }
      },
    );
  });

  group('로그인', () {
    test('로그인이 정상적으로 이루어지는 경우, SignUpResponseDto 반환함', () async {
      final supabaseUser = User.fromJson(mockUserJson());
      final session = Session.fromJson(mockSessionJson());

      when(
        () => mockSupabaseAuth.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => AuthResponse(user: supabaseUser, session: session),
      );

      final res = await datasource.signIn(
        SignInRequestDto(email: email, password: password),
      );

      expect(res, isA<SignInResponseDto>());
      expect(res.accessToken, isNotNull);
      expect(res.refreshToken, isNotNull);

      verify(
        () => mockSupabaseAuth.signInWithPassword(
          email: email,
          password: password,
        ),
      ).called(1);
    });

    test(
      '로그인 시 이메일이나 비밀번호가 틀린 경우 에러, 에러코드 INVALID_CREDENTIAL, 에러메세지 email or password is wrong로 내보내야 함',
      () async {
        when(
          () => mockSupabaseAuth.signInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(AuthException('invalid credentials'));

        try {
          await datasource.signIn(
            SignInRequestDto(email: email, password: password),
          );
          fail('인증 오류로 살패해야 함');
        } on CustomException catch (e) {
          expect(e.code, ErrorCode.invalidCredential);
          expect(e.message, 'email or password is wrong');
        } catch (e) {
          fail('오류 처리가 잘못됨');
        }

        verify(
          () => mockSupabaseAuth.signInWithPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      },
    );
  });
}
