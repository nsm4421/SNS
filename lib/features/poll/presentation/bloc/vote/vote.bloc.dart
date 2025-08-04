import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/poll/domain/entity/option.entity.dart';
import 'package:sns/features/poll/domain/entity/topic_detail.entity.dart';
import 'package:sns/features/poll/domain/usecase/poll.usecases.dart';

part 'vote.state.dart';

part 'vote.event.dart';

@injectable
class VoteBloc extends Bloc<VoteEvent, VoteState> with AppLogger {
  final PollUseCases _useCases;
  final String _topicId;
  late TopicDetailEntity _topic;

  VoteBloc({
    @factoryParam required String topicId,
    required PollUseCases useCases,
  }) : _topicId = topicId,
       _useCases = useCases,
       super(const VoteState.idle()) {
    on<MountVoteEvent>(_onMount);
    on<CastVoteEvent>(_onSubmit);
    on<CancelVoteEvent>(_onCancel);
  }

  Future<void> _onMount(
    MountVoteEvent event,
    Emitter<VoteState> emit,
  ) async {
    try {
      emit(const VoteState.idle());
      await _useCases.getTopicDetail
          .call(_topicId)
          .then(
            (res) => res.fold(
              (l) {
                logger.e(l);
                emit(const VoteState.error('getting topic data fails'));
              },
              (r) {
                _topic = r;
                if (_topic.selected == null) {
                  emit(VoteState.unVoted(_topic));
                } else {
                  emit(VoteState.voted(_topic));
                }
              },
            ),
          );
    } catch (error) {
      logger.e(error);
      emit(const VoteState.error('error occurs'));
    }
  }

  Future<void> _onSubmit(
    CastVoteEvent event,
    Emitter<VoteState> emit,
  ) async {
    try {
      emit(VoteState.unVoted(_topic, isLoading: true));
      await _useCases.castVote
          .call(topicId: _topicId, optionId: event.selected.id)
          .then(
            (res) => res.fold(
              (l) {
                logger.e(l);
                emit(const VoteState.error('fail to cast vote'));
              },
              (r) {
                _topic = r ?? _topic;
                emit(VoteState.voted(_topic));
              },
            ),
          );
    } catch (error) {
      logger.e(error);
      emit(const VoteState.error('error occurs'));
    }
  }

  Future<void> _onCancel(
    CancelVoteEvent event,
    Emitter<VoteState> emit,
  ) async {
    try {
      emit(VoteState.voted(_topic, isLoading: true));
      await _useCases.cancelVote
          .call(topicId: _topicId, optionId: _topic.selected!.id)
          .then(
            (res) => res.fold(
              (l) {
                logger.e(l);
                emit(const VoteState.error('fail to cancel vote'));
              },
              (r) {
                emit(VoteState.unVoted(_topic));
              },
            ),
          );
    } catch (error) {
      logger.e(error);
      emit(const VoteState.error('error occurs'));
    }
  }
}
