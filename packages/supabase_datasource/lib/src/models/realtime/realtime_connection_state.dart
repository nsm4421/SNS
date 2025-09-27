import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class RealtimeConnState {
  final bool isConnected;
  final String? reason; // 최근 에러/이유 (있다면)
  const RealtimeConnState(this.isConnected, {this.reason});
}
