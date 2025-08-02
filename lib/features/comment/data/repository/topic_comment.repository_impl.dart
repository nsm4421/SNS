import 'package:injectable/injectable.dart';
import 'package:sns/features/comment/comment.export.dart';
import 'package:sns/features/comment/data/model/topic/topic_comment.model.dart';
import 'package:sns/features/comment/data/repository/abs_comment.repository_impl.dart';
import 'package:sns/features/comment/domain/entity/topic/topic_comment.entity.dart';
import 'package:sns/features/comment/domain/repository/topic_comment.repository.dart';

@LazySingleton(as: TopicCommentRepository)
class TopicCommentRepositoryImpl
    extends AbsCommentRepositoryImpl<TopicCommentModel, TopicCommentEntity>
    implements TopicCommentRepository {
  final TopicCommentDataSource remoteDataSource;

  TopicCommentRepositoryImpl({required this.remoteDataSource})
    : super(
        remoteDataSource: remoteDataSource,
        convert: TopicCommentEntity.from,
      );
}
