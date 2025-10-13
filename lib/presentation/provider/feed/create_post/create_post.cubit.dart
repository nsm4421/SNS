import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/domain/usecase/usecase.export.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

part 'create_post.state.dart';

part 'create_post.cubit.freezed.dart';

@injectable
class CreatePostCubit extends Cubit<CreatePostState> {
  CreatePostCubit(this._feedUseCases) : super(const CreatePostState()) {
    _clientPostId = const Uuid().v4();
  }

  late final String _clientPostId;

  final FeedUseCases _feedUseCases;

  static const int _maxAssetCount = 5;

  String get postId => _clientPostId;

  Future<void> updateContent(String content) async {
    emit(state.copyWith(content: content));
    emit(state.copyWith(isSubmittable: _validate()));
  }

  void initState() {
    emit(
      state.copyWith(
        status: ComposeStatus.idle,
        errorMessage: null,
        isSubmittable: _validate(),
      ),
    );
  }

  Future<void> selectAssets(List<AssetEntity> selected) async {
    emit(state.copyWith(assets: selected.take(_maxAssetCount).toList()));
    emit(state.copyWith(isSubmittable: _validate()));
  }

  void removeMediaAt(int index) {
    if (index < 0 || index >= state.assets.length) return;
    final next = [...state.assets]..removeAt(index);
    final nextProgress = Map.of(state.perItemProgress)..remove(index);
    final remapped = <int, double>{};
    for (var i = 0; i < next.length; i++) {
      remapped[i] = nextProgress[i] ?? 0.0;
    }
    emit(
      state.copyWith(
        assets: next,
        perItemProgress: remapped,
        overallProgress: _calcOverall(remapped, next.length),
      ),
    );
    emit(state.copyWith(isSubmittable: _validate()));
  }

  void updateVisibility(bool isPublic) {
    emit(state.copyWith(isPublic: isPublic));
  }

  Future<void> submit() async {
    // 제출중이거나 입력내용이 충분하지 않은 경우 종료
    if (!state.isSubmittable || state.status == ComposeStatus.submitting) {
      appLogger.w('submit canceled');
      return;
    }

    // 로딩중으로 상태 변경
    emit(
      state.copyWith(
        status: ComposeStatus.submitting,
        isSubmittable: false,
        errorMessage: null,
      ),
    );

    // DB에 포스트 정보 저장
    appLogger.t('_clientPostId:$_clientPostId');

    // 파일 업로드
    List<String> storagePaths = [];
    if (state.assets.isNotEmpty) {
      for (final (idx, asset) in state.assets.indexed) {
        final file = await asset.file;
        if (file == null) {
          emit(
            state.copyWith(
              status: ComposeStatus.failure,
              errorMessage: 'File Upload failed!',
            ),
          );
          return;
        }
        final fileUploadRes = await _feedUseCases.uploadPostMedia.call(
          clientPostId: _clientPostId,
          file: file,
          onProgress: (p) {
            final updated = Map<int, double>.from(state.perItemProgress)
              ..[idx] = p.clamp(0.0, 1.0);
            emit(
              state.copyWith(
                perItemProgress: updated,
                overallProgress: _calcOverall(updated, state.assets.length),
              ),
            );
          },
        );
        if (fileUploadRes.isLeft()) {
          emit(
            state.copyWith(
              status: ComposeStatus.failure,
              errorMessage: 'File Upload failed!',
            ),
          );
          return;
        }
        // DB에 포스트 정보 저장
        storagePaths.add(fileUploadRes.getRight().getOrElse(() => ''));
      }
    }

    // DB에 포스트 정보 저장
    appLogger.t('saving post data');
    final createPostRes = await _feedUseCases.savePostOnDb.call(
      clientPostId: _clientPostId,
      content: state.content.trim(),
      storagePaths: storagePaths,
      mimeTypes: state.assets.map((e) => e.mimeType ?? 'bin').toList(),
      widths: state.assets.map((e) => e.width).toList(),
      heights: state.assets.map((e) => e.height).toList(),
    );
    if (createPostRes.isLeft()) {
      emit(
        state.copyWith(
          status: ComposeStatus.failure,
          errorMessage: createPostRes
              .swap()
              .getOrElse((_) => const Failure('create post fails'))
              .message,
        ),
      );
      return;
    }

    emit(state.copyWith(status: ComposeStatus.success, errorMessage: null));
  }

  bool _validate() {
    final hasText = state.content.trim().isNotEmpty;
    final hasMedia = state.assets.isNotEmpty;
    final underLimit = state.assets.length <= _maxAssetCount;
    return (hasText || hasMedia) && underLimit;
  }

  double _calcOverall(Map<int, double> per, int n) {
    if (n == 0) return 0.0;
    final sum = per.values.fold<double>(0.0, (a, b) => a + b);
    return (sum / max(n, 1)).clamp(0.0, 1.0);
  }
}
