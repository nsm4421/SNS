import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/extension/build_context.extension.dart';
import 'package:sns/core/extension/string.extension.dart';
import 'package:sns/core/provider/simple_data_cubit/simple_data.cubit.dart';
import 'package:sns/presentation/component/loading_overlay.widget.dart';
import 'package:sns/presentation/provider/auth/sign_up/sign_up.cubit.dart';
import 'package:sns/presentation/router/app_router.dart';

part 'sign_up.screen.dart';

part 'sign_up_form.fragment.dart';

part 'sign_up_button.widget.dart';

@RoutePage()
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SignUpCubit>(),
      child: BlocListener<SignUpCubit, SimpleDataState<SignUpData>>(
        listener: (context, state) {
          if (state.status == Status.success) {
            context.showSuccessSnackBar('회원가입 성공!');
            context.pop();
          } else if (state.status == Status.error) {
            context.showErrorSnackBar(state.errorMessage);
          }
        },
        child: BlocBuilder<SignUpCubit, SimpleDataState<SignUpData>>(
          builder: (context, state) {
            return LoadingOverlay(
              isLoading: state.status != Status.initial,
              child: const SignUpScreen(),
            );
          },
        ),
      ),
    );
  }
}
