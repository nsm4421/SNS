part of 'display.bloc.dart';

@freezed
class DisplayState<T> with _$DisplayState<T> {
  DisplayState({
    this.status = DisplayStatus.initial,
    this.items = const [],
    this.nextCursor,
    this.failure,
  });

  final DisplayStatus status;
  final List<T> items;
  final String? nextCursor;
  final Failure? failure;

  bool get isEmpty => items.isEmpty && failure == null;

  bool get isEnd => nextCursor == null;
}
