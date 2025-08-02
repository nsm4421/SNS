import 'package:sns/features/comment/domain/entity/topic/topic_comment.entity.dart';
import 'package:sns/features/comment/domain/repository/abs_comment.repository.dart';

abstract interface class TopicCommentRepository
    implements AbsCommentRepository<TopicCommentEntity> {}
