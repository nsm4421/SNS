import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/dependency_injection/dependency_injection.dart';
import 'package:sns/core/util/bloc/simple_cubit.dart';
import 'package:sns/features/auth/presentation/bloc/sign_up/sign_up.cubit.dart';
import 'form.fragment.dart';
import 'submit_button.widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignUpCubit>(),
      child: BlocListener<SignUpCubit, SimpleCubitState>(
        listener: (context, state) {
          if (state.status == Status.success) {
            // TODO : 로그인 페이지로 라우팅
          } else if (state.status == Status.error) {
            // TODO : 오류 메세지 띄우기
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(title: const Text('Sign Up')),
          body: const SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: FormFragment(),
                    ),
                  ),
                ),
                SubmitButtonWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
