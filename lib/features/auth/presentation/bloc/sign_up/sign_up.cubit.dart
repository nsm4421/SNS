import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/util/bloc/simple_cubit.dart';
import 'package:sns/core/util/logger/sington_logger.util.dart';
import 'package:sns/features/auth/domain/usecase/auth.usecases.dart';
import 'package:sns/features/auth/domain/usecase/scenario/sign_up.usecase.dart';

part 'sign_up_data.dart';

part 'sign_up.cubit.g.dart';

@injectable
class SignUpCubit extends SimpleCubit<SignUpData> with AppLogger {
  late final SignUpUseCase _useCase;
  late final GlobalKey<FormState> _formKey;

  SignUpCubit({required AuthUseCases useCases}) : super(SignUpData()) {
    _useCase = useCases.signUp;
    _formKey = GlobalKey<FormState>(debugLabel: 'sign-up-form-key');
  }

  GlobalKey<FormState> get formKey => _formKey;

  void handleData({String? email, String? password, String? username}) {
    emit(
      state.copyWith(
        data: state.data.copyWith(
          email: email ?? state.data.email,
          password: password ?? state.data.password,
          username: username ?? state.data.username,
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

      await _useCase
          .call(
            email: state.data.email,
            password: state.data.password,
            username: state.data.username,
          )
          .then(
            (res) => res.fold(
              (l) {
                logger.e(l);
                emit(
                  state.copyWith(status: Status.error, errorMessage: l.message),
                );
              },
              (_) {
                emit(state.copyWith(status: Status.success));
              },
            ),
          );
    } catch (error) {
      logger.e(error);
      emit(state.copyWith(status: Status.error, errorMessage: 'error occurs'));
      await Future.delayed(const Duration(seconds: 1));
      emit(
        state.copyWith(status: Status.initial).copyWithNull(errorMessage: true),
      );
    }
  }
}
