part of 'simple_display.bloc.dart';

abstract class SimpleDisplayEvent {}

class RefreshDisplayEvent extends SimpleDisplayEvent {
  final int limit;

  RefreshDisplayEvent({this.limit = 20});
}

class FetchDisplayDataEvent extends SimpleDisplayEvent {
  final int limit;

  FetchDisplayDataEvent({this.limit = 20});
}
