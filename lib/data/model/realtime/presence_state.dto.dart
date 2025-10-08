import 'package:freezed_annotation/freezed_annotation.dart';

typedef PresencePayload = Map<String, dynamic>;

@immutable
class PresenceStateDto {
  /// user_id -> 디바이스별 payload 리스트(동일 유저가 여러 기기에서 접속 가능)
  final Map<String, List<Map<String, dynamic>>> byUser;

  const PresenceStateDto(this.byUser);

  List<Map<String, dynamic>> devicesOf(String userId) =>
      byUser[userId] ?? const [];
}
