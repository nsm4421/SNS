import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/usecase/usecase.export.dart';

part 'toggle_like_on_post.state.dart';

part 'toggle_like_on_post.cubit.g.dart';

@injectable
class ToggleLikeOnPostCubit extends Cubit<ToggleLikeOnPostState> {
  final FeedUseCases _feedUseCases;
  final FeedPostEntityWithAuthor _feed;
  static const Duration _duration = Duration(milliseconds: 300);

  ToggleLikeOnPostCubit(
    @factoryParam this._feed, {
    required FeedUseCases feedUseCases,
  }) : _feedUseCases = feedUseCases,
       super(
         ToggleLikeOnPostState(
           isLoading: false,
           likedByMe: _feed.likedByMe,
           likeCount: _feed.likeCount,
         ),
       );

  Future<void> toggle([Duration? duration]) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    await _feedUseCases.toggleLike
        .call(_feed.postId)
        .then(
          (res) => res.match(
            (l) {
              debugPrint(l.repr);
            },
            (r) {
              emit(
                state.copyWith(
                  isLoading: false,
                  likedByMe: r.$1,
                  likeCount: r.$2,
                ),
              );
            },
          ),
        );
    await Future.delayed(duration ?? _duration, () {
      emit(state.copyWith(isLoading: false));
    });
  }
}
