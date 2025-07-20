import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sns/features/auth/domain/usecase/sign_up.usecase.dart';
import 'package:sns/features/auth/presentation/bloc/sign_up.bloc.dart';

import '../../data/repository/mock_auth.repository.dart';

void main() {
  late SignUpBloc signUpBloc;
  setUp(() {
    signUpBloc = SignUpBloc(SignUpUseCase(MockAuthRepositoryImpl()));
  });

  blocTest(
    'emit',
    build: () => signUpBloc,
    act: (bloc) => bloc.add(
      SignUpSubmitted(
        email: 'nsm4421@naver.com',
        password: '951221',
        username: 'karma',
      ),
    ),
    expect: () => [SignUpLoading(), SignUpSuccess()],
  );
}
