import 'dart:io';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/provider/simple_data_cubit/simple_data.cubit.dart';
import 'package:sns/domain/usecase/auth_usecases.dart';
import 'package:sns/domain/usecase/screnario/auth/sign_up.usecase.dart';

part 'sign_up_data.dart';

part 'sign_up.cubit.g.dart';

@injectable
class SignUpCubit extends SimpleDataCubit<SignUpData> {
  late final SignUpUseCase _useCase;
  late final GlobalKey<FormState> _formKey;

  SignUpCubit(AuthUseCases authUseCases) : super(SignUpData()) {
    _useCase = authUseCases.signUp;
    _formKey = GlobalKey<FormState>();
  }

  GlobalKey<FormState> get formKey => _formKey;

  void updateEmail(String v) {
    emit(state.copyWith(data: state.data.copyWith(email: v)));
  }

  void updatePassword(String v) {
    emit(state.copyWith(data: state.data.copyWith(password: v)));
  }

  void updateUsername(String v) {
    emit(state.copyWith(data: state.data.copyWith(username: v)));
  }

  void updateProfileImage(File? v) {
    emit(
      state.copyWith(
        data: state.data
            .copyWith(profileImage: v)
            .copyWithNull(profileImage: v == null),
      ),
    );
  }

  Future<void> submit() async {
    try {
      _formKey.currentState?.save();
      final ok = _formKey.currentState?.validate();
      if (ok == null || !ok) {
        return;
      }

      emit(state.copyWith(status: Status.loading));
      await _useCase
          .call(
            email: state.data.email,
            password: state.data.password,
            username: state.data.username,
            profileImage: state.data.profileImage,
          )
          .then(
            (res) => res.fold(
              (l) async {
                emit(
                  state.copyWith(status: Status.error, errorMessage: l.message),
                );
                await resetState();
              },
              (r) {
                emit(state.copyWith(status: Status.success));
              },
            ),
          );
    } catch (e) {
      emit(
        state.copyWith(status: Status.error, errorMessage: '회원가입 중 오류가 발생했습니다'),
      );
      await resetState();
    }
  }
}
