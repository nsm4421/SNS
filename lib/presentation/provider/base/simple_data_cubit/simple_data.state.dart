part of 'simple_data.cubit.dart';

@CopyWith()
class SimpleDataState<T> {
  final Status status;
  final String errorMessage;
  final T data;

  SimpleDataState({
    this.status = Status.initial,
    this.errorMessage = '',
    required this.data,
  });
}
