import 'package:injectable/injectable.dart';
import 'package:sns/features/comment/domain/entity/topic/topic_comment.entity.dart';
import 'package:sns/features/comment/domain/repository/topic_comment.repository.dart';
import 'abs_comment.usecases.dart';

@lazySingleton
class TopicCommentUseCases extends AbsCommentUseCases<TopicCommentEntity> {
  TopicCommentUseCases({required TopicCommentRepository repository})
    : super(repository);
}
