import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/core/constant/status.constant.dart';

@sealed
abstract class SimpleDisplayEvent {}

class InitDisplayEvent extends SimpleDisplayEvent {
  final DisplayStatus? status;
  final List? data;
  final String? errorMessage;

  InitDisplayEvent({this.status, this.data, this.errorMessage});
}

class RefreshDisplayEvent extends SimpleDisplayEvent {
  final int limit;

  RefreshDisplayEvent({this.limit = 20});
}

class FetchDisplayDataEvent extends SimpleDisplayEvent {
  final int limit;

  FetchDisplayDataEvent({this.limit = 20});
}
