import 'package:flutter/material.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/provider/simple_data_cubit/simple_data.cubit.dart';
import 'package:sns/domain/usecase/auth_usecases.dart';
import 'package:sns/domain/usecase/screnario/auth/sign_in.usecase.dart';

part 'sign_in_data.dart';

part 'sign_in.cubit.g.dart';

@injectable
class SignInCubit extends SimpleDataCubit<SignInData> {
  late final SignInUseCase _useCase;
  late final GlobalKey<FormState> _formKey;

  SignInCubit(AuthUseCases useCases) : super(SignInData()) {
    _useCase = useCases.signIn;
    _formKey = GlobalKey<FormState>();
  }

  GlobalKey<FormState> get formKey => _formKey;

  void updateEmail(String v) {
    emit(state.copyWith(data: state.data.copyWith(email: v)));
  }

  void updatePassword(String v) {
    emit(state.copyWith(data: state.data.copyWith(password: v)));
  }

  Future<void> submit() async {
    try {
      _formKey.currentState?.save();
      final ok = _formKey.currentState?.validate();
      if (ok == null || !ok) {
        return;
      }

      await _useCase
          .call(email: state.data.email, password: state.data.password)
          .then(
            (res) => res.fold(
              (l) async {
                emit(
                  state.copyWith(status: Status.error, errorMessage: l.message),
                );
                await resetState();
              },
              (r) {
                emit(state.copyWith(status: Status.success, errorMessage: ''));
              },
            ),
          );
    } catch (e) {
      emit(
        state.copyWith(status: Status.error, errorMessage: '로그인 도중 오류가 발생했습니다'),
      );
      await resetState();
    }
  }
}
