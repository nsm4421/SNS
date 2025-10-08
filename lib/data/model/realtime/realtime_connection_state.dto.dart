import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class RealtimeConnStateDto {
  final bool isConnected;
  final String? reason; // 최근 에러/이유 (있다면)
  const RealtimeConnStateDto(this.isConnected, {this.reason});
}
