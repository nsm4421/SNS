import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/domain/entity/feed/post.entity.dart';
import 'package:sns/domain/usecase/feed_usecases.dart';
import 'package:sns/domain/usecase/scenario/feed/create_post_comment.usecase.dart';
import 'package:sns/presentation/provider/base/simple_data_cubit/simple_data.cubit.dart';

part 'create_parent_post_comment_data.dart';

part 'create_parent_post_comment.cubit.g.dart';

@injectable
class CreateParentPostCommentCubit
    extends SimpleDataCubit<CreateParentPostCommentData> {
  late final CreatePostCommentUseCase _useCase;
  final PostEntity _post;

  CreateParentPostCommentCubit({
    @factoryParam required PostEntity post,
    required FeedUseCases useCases,
  }) : _post = post,
       super(CreateParentPostCommentData(commentsCount: post.commentsCount)) {
    _useCase = useCases.createComment;
  }

  String get postId => _post.id;

  Future<void> submit(String content) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await _useCase
          .call(postId: _post.id, content: content, parentId: null)
          .then(
            (res) => res.fold(
              (l) async {
                emit(
                  state.copyWith(status: Status.error, errorMessage: l.message),
                );
              },
              (r) {
                emit(
                  state.copyWith(
                    status: Status.success,
                    errorMessage: '',
                    // 성공 . 가장 최근 생성된 댓글 id, 댓글 개수 업데이트
                    data: state.data.copyWith(
                      latestCreatedCommentId: r,
                      commentsCount: state.data.commentsCount + 1,
                    ),
                  ),
                );
              },
            ),
          );
    } catch (error) {
      emit(state.copyWith(status: Status.error, errorMessage: '댓글 작성요청 실패'));
    } finally {
      await resetState();
    }
  }
}
