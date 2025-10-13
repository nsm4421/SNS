part of 'create_post.cubit.dart';

@freezed
class CreatePostState with _$CreatePostState {
  final ComposeStatus status;
  final String content;
  final bool isPublic;
  final List<AssetEntity> assets;
  final String? errorMessage;
  final double overallProgress;
  final Map<int, double> perItemProgress;
  final bool isSubmittable;

  const CreatePostState({
    this.status = ComposeStatus.idle,
    this.content = '',
    this.isPublic = true,
    this.assets = const [],
    this.errorMessage,
    this.overallProgress = 0,
    this.perItemProgress = const {},
    this.isSubmittable = false,
  });
}
