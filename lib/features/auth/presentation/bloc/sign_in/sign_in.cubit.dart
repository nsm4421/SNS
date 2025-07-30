import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/util/bloc/simple_cubit.dart';
import 'package:sns/core/util/logger/sington_logger.util.dart';
import 'package:sns/features/auth/domain/usecase/auth.usecases.dart';
import 'package:sns/features/auth/domain/usecase/scenario/sign_in.usecase.dart';

part 'sign_in_data.dart';

part 'sign_in.cubit.g.dart';

@injectable
class SignInCubit extends SimpleCubit<SignInData> with AppLogger {
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

      await _useCase
          .call(email: state.data.email, password: state.data.password)
          .then(
            (res) => res.fold(
              (l) async {
                logger.e(l);
                emit(
                  state.copyWith(status: Status.error, errorMessage: l.message),
                );
                await resetStatus();
              },
              (_) {
                emit(state.copyWith(status: Status.success));
              },
            ),
          );
    } catch (error) {
      logger.e(error);
      emit(state.copyWith(status: Status.error, errorMessage: 'error occurs'));
      await resetStatus();
    }
  }
}
