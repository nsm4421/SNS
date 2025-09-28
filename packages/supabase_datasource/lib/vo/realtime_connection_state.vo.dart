import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class RealtimeConnStateVo {
  final bool isConnected;
  final String? reason; // 최근 에러/이유 (있다면)
  const RealtimeConnStateVo(this.isConnected, {this.reason});
}
