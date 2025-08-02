import 'package:injectable/injectable.dart';
import 'package:sns/features/comment/domain/entity/topic/topic_comment.entity.dart';
import 'package:sns/features/comment/domain/usecase/topic_comment.usecase.dart';

import '../abs/abs_display_comments.bloc.dart';

@injectable
class DisplayTopicCommentsBloc
    extends AbsDisplayCommentsBloc<TopicCommentEntity> {
  DisplayTopicCommentsBloc({
    required TopicCommentUseCases useCases,
    @factoryParam required String topicId,
  }) : super(useCases: useCases, refId: topicId);
}
