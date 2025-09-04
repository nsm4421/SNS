import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/logger/app_logger.dart';
import 'package:sns/domain/entity/feed/post.entity.dart';
import 'package:sns/domain/usecase/feed_usecases.dart';
import 'package:sns/domain/usecase/scenario/feed/toggle_post_like.usecase.dart';

part 'like_post.state.dart';

part 'like_post.cubit.g.dart';

@injectable
class LikePostCubit extends Cubit<LikePostState> with AppLogger {
  late final TogglePostLikeUseCase _useCase;
  final PostEntity _feed;

  LikePostCubit(@factoryParam this._feed, {required FeedUseCases useCases})
    : super(
        LikePostState(
          tappable: true,
          likedByMe: _feed.likedByMe,
          likesCount: _feed.likesCount,
        ),
      ) {
    _useCase = useCases.toggleLike;
  }

  Future<void> handleToggle() async {
    if (!state.tappable) return;
    emit(state.copyWith(tappable: false));
    try {
      final res = await _useCase.call(_feed.id);
      if (res.isLeft) return;
      emit(
        state.copyWith(
          likesCount: res.right ?? state.likesCount,
          likedByMe: !state.likedByMe,
        ),
      );
    } catch (e) {
      logger.e(e);
    } finally {
      emit(state.copyWith(tappable: true));
    }
  }
}
