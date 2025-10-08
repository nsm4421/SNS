import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:supabase/supabase.dart';
import 'package:logger/logger.dart';
import 'package:karma/data/model/model.export.dart';

part 'user_presence.datasource_impl.dart';

abstract class UserPresenceDataSource {
  /// 현재 온라인 userId 집합 스트림
  Stream<Set<String>> onlineUserIdsStream(String topic);

  /// 해당 topic(예: 'presence:org:123')으로 입장(트래킹 시작)
  Future<void> enter({
    required String topic,
    required String userId,
    Map<String, dynamic>? metadata,
    bool includeSelfInState = true,
  });

  /// 해당 topic에서 나가기
  Future<void> leave(String topic);

  Future<void> clearResources();
}
