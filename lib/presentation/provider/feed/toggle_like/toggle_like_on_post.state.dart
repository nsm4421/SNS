part of 'toggle_like_on_post.cubit.dart';

@CopyWith()
class ToggleLikeOnPostState {
  final bool isLoading;
  final int likeCount;
  final bool likedByMe;

  ToggleLikeOnPostState({
    this.isLoading = false,
    this.likeCount = 0,
    this.likedByMe = false,
  });
}
