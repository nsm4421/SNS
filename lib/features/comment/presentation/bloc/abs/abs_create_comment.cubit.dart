import 'package:sns/core/core.export.dart';
import 'package:sns/features/comment/domain/usecase/abs_comment.usecases.dart';

abstract class AbsCreateCommentCubit extends SimpleCubit<String>
    with AppLogger {
  late final CreateCommentUseCase _useCase;
  final String _refId;

  AbsCreateCommentCubit({
    required AbsCommentUseCases useCases,
    required String refId,
  }) : _refId = refId,
       super('') {
    _useCase = useCases.create;
  }

  updateContent(String content) {
    emit(state.copyWith(data: content));
  }

  Future<void> submit() async {
    try {
      emit(state.copyWith(status: Status.loading));
      await _useCase
          .call(refId: _refId, content: state.data)
          .then(
            (res) => res.fold(
              (l) {
                emit(
                  state.copyWith(status: Status.error, errorMessage: l.message),
                );
                resetStatus();
              },
              (r) {
                emit(state.copyWith(status: Status.success));
              },
            ),
          );
    } catch (error) {
      logger.e(error);
      emit(state.copyWith(status: Status.error, errorMessage: 'error occurs'));
      resetStatus();
    }
  }
}
