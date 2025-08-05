import 'package:sns/features/comment/data/model/abs/abs_comment.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'abs_remote_comment.datasource.dart';

abstract class AbsRemoteCommentDataSourceImpl<T extends AbsCommentModel>
    implements AbsRemoteCommentDataSource<T> {
  late final PostgrestQueryBuilder _qb;
  final T Function(Map<String, dynamic>) fromJson;
  final String refCol;

  AbsRemoteCommentDataSourceImpl({
    required String tableName,
    required this.fromJson,
    required this.refCol,
    required SupabaseClient supabaseClient,
  }) {
    _qb = supabaseClient.rest.from(tableName);
  }

  @override
  Future<String> create({
    required String refId,
    required String content,
  }) async {
    return await _qb
        .insert({refCol: refId, 'content': content})
        .select()
        .single()
        .then((res) => res['id']);
  }

  @override
  Future<void> deleteById(String commentId) async {
    await _qb.delete().eq('id', commentId);
  }

  @override
  Future<Iterable<T>> fetchCommentsByRef({
    int limit = 20,
    required String refId,
    DateTime? cursor,
  }) async {
    final query = _qb.select('*, creator:users(*)').eq(refCol, refId);
    if (cursor != null) {
      query.lt('created_at', cursor.toIso8601String());
    }
    return await query
        .order('created_at')
        .limit(limit)
        .then((res) => res.map(fromJson));
  }

  @override
  Future<T> findById(String commentId) async {
    return _qb
        .select('*, creator:users(*)')
        .eq('id', commentId)
        .single()
        .then(fromJson);
  }
}
