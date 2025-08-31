import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'simple_data.state.dart';

part 'simple_data.cubit.g.dart';

class SimpleDataCubit<T> extends Cubit<SimpleDataState<T>> {
  SimpleDataCubit(T data) : super(SimpleDataState(data: data));

  void updateState({Status? status, String? errorMessage, T? data}) {
    emit(
      state.copyWith(
        status: status ?? state.status,
        errorMessage: errorMessage ?? state.errorMessage,
        data: data ?? state.data,
      ),
    );
  }

  Future<void> resetState([Duration? duration]) async {
    await Future.delayed(duration ?? const Duration(microseconds: 500));
    emit(state.copyWith(status: Status.initial, errorMessage: ''));
  }
}
