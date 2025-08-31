import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/extension/build_context.extension.dart';
import 'package:sns/core/extension/string.extension.dart';
import 'package:sns/presentation/provider/base/simple_data_cubit/simple_data.cubit.dart';
import 'package:sns/presentation/provider/auth/sign_in/sign_in.cubit.dart';
import 'package:sns/presentation/router/app_router.dart';

part 'sign_in.screen.dart';

part 'sign_in_form.fragment.dart';

part 'sign_in_buttons.widget.dart';

@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SignInCubit>(),
      child: BlocListener<SignInCubit, SimpleDataState<SignInData>>(
        listener: (context, state) {
          if (state.status == Status.success) {
            context
              ..showSuccessSnackBar('로그인 성공!')
              ..read<SignInCubit>().updateState(status: Status.initial)
              ..router.replace(const HomeRoute());
          } else if (state.status == Status.error) {
            context.showErrorSnackBar(state.errorMessage);
          }
        },
        child: const SignInScreen(),
      ),
    );
  }
}
