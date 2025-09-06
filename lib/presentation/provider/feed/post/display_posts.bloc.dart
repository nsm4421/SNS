import 'package:either_dart/src/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/entity/feed/post.entity.dart';
import 'package:sns/domain/usecase/feed_usecases.dart';
import 'package:sns/domain/usecase/scenario/feed/fetch_posts.usecase.dart';
import 'package:sns/presentation/provider/base/simple_display_bloc/simple_display.bloc.dart';

part 'display_posts.event.dart';

@injectable
class DisplayPostsBloc extends SimpleDisplayBloc<PostEntity> {
  late final FetchPostsUseCase _useCase;

  DisplayPostsBloc(FeedUseCases useCases) : super() {
    _useCase = useCases.fetchPosts;
    on<UpdatePostCommentsCountEvent>(_updatePostCommentsCount);
  }

  @override
  Future<Either<Failure, Page<PostEntity>>> fetch({
    String? cursor,
    int limit = 20,
  }) async {
    return await _useCase.call(
      cursor: cursor ?? DateTime.now().toUtc().toIso8601String(),
      limit: limit,
    );
  }

  // 댓글개수 업데이트
  _updatePostCommentsCount(
    UpdatePostCommentsCountEvent event,
    Emitter<SimpleDisplayState<PostEntity>> emit,
  ) {
    emit(
      state.copyWith(
        data: state.data
            .map(
              (e) => e.id == event.postId
                  ? e.copyWith(likesCount: e.likesCount + event.delta)
                  : e,
            )
            .toList(),
      ),
    );
  }
}
