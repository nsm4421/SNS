part of 'simple_display.bloc.dart';

@CopyWith(copyWithNull: true)
class SimpleDisplayState<T> {
  final DisplayStatus status;
  final String? nextCursor;
  final List<T> data;
  final String? errorMessage;

  SimpleDisplayState({
    this.status = DisplayStatus.unMounted,
    this.nextCursor,
    required this.data,
    this.errorMessage,
  });
}
