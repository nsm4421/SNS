import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constant/status.constant.dart';

part 'simple_cubit.g.dart';

@CopyWith(copyWithNull: true)
class SimpleCubitState<T> {
  final Status status;
  final String? errorMessage;
  final T data;

  SimpleCubitState({
    this.status = Status.initial,
    this.errorMessage,
    required this.data,
  });
}

abstract class SimpleCubit<T> extends Cubit<SimpleCubitState<T>> {
  SimpleCubit(T initData) : super(SimpleCubitState<T>(data: initData));

  resetStatus({Duration? duration}) async {
    await Future.delayed(duration ?? const Duration(seconds: 1));
    emit(
      state.copyWith(status: Status.initial).copyWithNull(errorMessage: true),
    );
  }
}
