import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/poll/domain/usecase/poll.usecases.dart';

part 'create_topic_data.dart';

part 'create_topic.cubit.g.dart';

@injectable
class CreateTopicCubit extends SimpleCubit<CreateTopicData> with AppLogger {
  late final CreateTopicUseCase _useCase;
  late final GlobalKey<FormState> _formKey;

  CreateTopicCubit(PollUseCases useCase)
    : super(CreateTopicData(title: '', description: '', options: [])) {
    _useCase = useCase.createTopic;
    _formKey = GlobalKey<FormState>(debugLabel: 'create-topic-form-key');
  }

  GlobalKey<FormState> get formKey => _formKey;

  void updateTitle(String title) {
    emit(state.copyWith(data: state.data.copyWith(title: title)));
  }

  void updateDescription(String description) {
    emit(state.copyWith(data: state.data.copyWith(description: description)));
  }

  void addOption(String option) {
    emit(
      state.copyWith(
        data: state.data.copyWith(options: [...state.data.options, option]),
      ),
    );
  }

  void removeOptionByIndex(int index) {
    final temp = [...state.data.options];
    temp.removeAt(index);
    emit(state.copyWith(data: state.data.copyWith(options: temp)));
  }

  Future<void> submit() async {
    _formKey.currentState?.save();
    final ok = _formKey.currentState?.validate();
    if (ok == null || !ok) {
      logger.w('validation fails');
      return;
    }

    try {
      await _useCase
          .call(
            title: state.data.title,
            description: state.data.description,
            options: state.data.options,
          )
          .then(
            (res) => res.fold(
              (l) async {
                logger.e(l);
                emit(
                  state.copyWith(status: Status.error, errorMessage: l.message),
                );
                await resetStatus();
              },
              (r) {
                emit(state.copyWith(status: Status.success));
              },
            ),
          );
    } catch (error) {
      logger.e(error);
      emit(state.copyWith(status: Status.error, errorMessage: 'error occurs'));
      await resetStatus();
    }
  }
}
