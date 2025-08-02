import 'package:sns/features/comment/data/datasource/remote/abs/abs_remote_comment.datasource_impl.dart';
import 'package:sns/features/comment/data/model/topic/topic_comment.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'topic_comment.datasource.dart';

class TopicCommentDataSourceImpl
    extends AbsRemoteCommentDataSourceImpl<TopicCommentModel>
    implements TopicCommentDataSource {
  TopicCommentDataSourceImpl(SupabaseClient supabaseClient)
    : super(
        tableName: 'topic_comments',
        refCol: 'topic_id',
        fromJson: TopicCommentModel.fromJson,
        supabaseClient: supabaseClient,
      );
}
