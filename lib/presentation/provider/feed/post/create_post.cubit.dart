import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/domain/usecase/scenario/feed/create_post.usecase.dart';
import 'package:sns/presentation/provider/base/simple_data_cubit/simple_data.cubit.dart';
import 'package:sns/domain/usecase/feed_usecases.dart';

part 'create_post_data.dart';

part 'create_post.cubit.g.dart';

@injectable
class CreateFeedCubit extends SimpleDataCubit<CreatePostData> {
  static const int _maxImageCount = 3;
  late final CreatePostUseCase _useCase;
  late final GlobalKey<FormState> _formKey;

  CreateFeedCubit(FeedUseCases useCases) : super(CreatePostData(images: [])) {
    _useCase = useCases.createPost;
    _formKey = GlobalKey<FormState>();
  }

  GlobalKey<FormState> get formKey => _formKey;

  int get maxImageCount => _maxImageCount;

  int get maxImageCountCanSelect => _maxImageCount - state.data.images.length;

  void updateContent(String v) {
    emit(state.copyWith(data: state.data.copyWith(content: v)));
  }

  void selectImages(List<XFile> selected) {
    emit(
      state.copyWith(
        data: state.data.copyWith(images: [...state.data.images, ...selected]),
      ),
    );
  }

  void unSelectImage(int index) {
    final temp = [...state.data.images];
    temp.removeAt(index);
    emit(state.copyWith(data: state.data.copyWith(images: temp)));
  }

  Future<void> submit() async {
    try {
      _formKey.currentState?.save();
      final ok = _formKey.currentState?.validate();
      if (ok == null || !ok) {
        return;
      } else if (state.data.content.isEmpty) {
        emit(state.copyWith(status: Status.error, errorMessage: '텍스트를 입력해주세요'));
        await resetState();
        return;
      }

      emit(state.copyWith(status: Status.loading));
      await _useCase
          .call(content: state.data.content, images: state.data.images)
          .then(
            (res) => res.fold(
              (l) async {
                emit(
                  state.copyWith(status: Status.error, errorMessage: l.message),
                );
                await resetState();
              },
              (r) {
                emit(state.copyWith(status: Status.success, errorMessage: ''));
              },
            ),
          );
    } catch (err) {
      emit(
        state.copyWith(status: Status.error, errorMessage: '피드 작성중 오류가 발생했습니다'),
      );
      await resetState();
    }
  }
}
