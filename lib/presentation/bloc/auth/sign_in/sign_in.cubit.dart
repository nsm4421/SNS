import 'dart:developer';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/util/bloc/simple_cubit.dart';
import 'package:sns/features/auth/domain/usecase/auth.usecases.dart';
import 'package:sns/features/auth/domain/usecase/scenario/sign_in.usecase.dart';

part 'sign_in_data.dart';

part 'sign_in.cubit.g.dart';

@injectable
class SignInCubit extends SimpleCubit<SignInData> {
  late final SignInUseCase _useCase;
  late final GlobalKey<FormState> _formKey;

  SignInCubit({required AuthUseCases useCases}) : super(SignInData()) {
    _useCase = useCases.signIn;
    _formKey = GlobalKey<FormState>(debugLabel: 'sign-in-form-key');
  }

  GlobalKey<FormState> get formKey => _formKey;

  void handleData({String? email, String? password}) {
    emit(
      state.copyWith(
        data: state.data.copyWith(
          email: email ?? state.data.email,
          password: password ?? state.data.password,
        ),
      ),
    );
  }

  Future<void> handleSubmit() async {
    try {
      final ok = _formKey.currentState?.validate();
      if (ok == null || !ok) {
        return;
      }
      _formKey.currentState?.save();
      await _useCase.call(
        email: state.data.email,
        password: state.data.password,
      );
      emit(state.copyWith(status: Status.success));
    } catch (error) {
      log(error.toString());
      emit(state.copyWith(status: Status.error, errorMessage: 'sign in fails'));
      await Future.delayed(const Duration(seconds: 1));
      emit(
        state.copyWith(status: Status.initial).copyWithNull(errorMessage: true),
      );
    }
  }
}
