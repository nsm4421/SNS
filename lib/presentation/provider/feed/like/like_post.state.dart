part of 'like_post.cubit.dart';

@CopyWith()
class LikePostState {
  final bool likedByMe;
  final int likesCount;
  final bool tappable;

  LikePostState({
    this.tappable = false,
    this.likedByMe = false,
    this.likesCount = 0,
  });
}
