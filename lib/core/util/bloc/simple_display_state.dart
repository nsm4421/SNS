part of 'simple_display_bloc.dart';

@CopyWith(copyWithNull: true)
class SimpleDisplayState<T extends BaseEntity> {
  final DisplayStatus status;
  final bool isEnd;
  final List<T> data;
  final String? errorMessage;

  SimpleDisplayState({
    this.status = DisplayStatus.initial,
    this.isEnd = false,
    required this.data,
    this.errorMessage,
  });
}
