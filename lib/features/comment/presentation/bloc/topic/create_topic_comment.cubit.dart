import 'package:injectable/injectable.dart';
import 'package:sns/features/comment/domain/usecase/topic_comment.usecase.dart';

import '../abs/abs_create_comment.cubit.dart';

@injectable
class CreateTopicCommentCubit extends AbsCreateCommentCubit {
  final String topicId;
  final TopicCommentUseCases useCases;

  CreateTopicCommentCubit({
    @factoryParam required this.topicId,
    required this.useCases,
  }) : super(refId: topicId, useCases: useCases);
}
