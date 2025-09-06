import 'package:either_dart/src/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/entity/feed/post.entity.dart';
import 'package:sns/domain/entity/feed/post_comment.entity.dart';
import 'package:sns/domain/usecase/feed_usecases.dart';
import 'package:sns/domain/usecase/scenario/feed/fetch_post_comments.usecase.dart';
import 'package:sns/presentation/provider/base/simple_display_bloc/simple_display.bloc.dart';

part 'display_post_comments.event.dart';

abstract class DisplayCommentBloc<T extends PostCommentEntity>
    extends SimpleDisplayBloc<T> {
  final String _postId;
  final String? _parentId;

  DisplayCommentBloc({required String postId, required String? parentId})
    : _postId = postId,
      _parentId = parentId {
    on<PostCommentCreatedEvent<T>>(_onCreated);
  }

  Future<void> _onCreated(
    PostCommentCreatedEvent<T> event,
    Emitter<SimpleDisplayState<T>> emit,
  ) async {
    emit(state.copyWith(data: [event.created, ...state.data]));
  }
}

@injectable
class DisplayParentCommentBloc
    extends DisplayCommentBloc<ParentPostCommentEntity> {
  late final FetchParentPostCommentsUseCase _useCase;

  DisplayParentCommentBloc({
    @factoryParam required PostEntity post,
    required FeedUseCases useCases,
  }) : super(postId: post.id, parentId: null) {
    _useCase = useCases.fetchParentComments;
  }

  @override
  Future<Either<Failure, Page<ParentPostCommentEntity>>> fetch({
    String? cursor,
    int limit = 20,
  }) async {
    return await _useCase.call(
      cursor: cursor ?? DateTime.now().toUtc().toIso8601String(),
      limit: limit,
      postId: _postId,
    );
  }
}

@injectable
class DisplayChildCommentBloc
    extends DisplayCommentBloc<ChildPostCommentEntity> {
  late final FetchChildPostCommentsUseCase _useCase;

  DisplayChildCommentBloc({
    @factoryParam required ParentPostCommentEntity parentComment,
    required FeedUseCases useCases,
  }) : super(postId: parentComment.postId, parentId: parentComment.id) {
    _useCase = useCases.fetchChildComments;
  }

  @override
  Future<Either<Failure, Page<ChildPostCommentEntity>>> fetch({
    String? cursor,
    int limit = 20,
  }) async {
    return await _useCase.call(
      cursor: cursor ?? DateTime.now().toUtc().toIso8601String(),
      limit: limit,
      postId: _postId,
      parentId: _parentId!,
    );
  }
}
