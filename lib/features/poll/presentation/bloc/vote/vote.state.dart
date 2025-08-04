part of 'vote.bloc.dart';

class VoteState {
  final TopicDetailEntity? topic;
  final CastVoteStatus status;
  final bool isLoading;
  final String? errorMessage;

  const VoteState._({
    this.status = CastVoteStatus.idle,
    this.topic,
    this.isLoading = false,
    this.errorMessage,
  });

  const VoteState.idle()
    : this._(status: CastVoteStatus.idle, isLoading: true);

  const VoteState.unVoted(TopicDetailEntity topic, {bool isLoading = false})
    : this._(
        status: CastVoteStatus.unVoted,
        topic: topic,
        isLoading: isLoading,
      );

  const VoteState.voted(TopicDetailEntity topic, {bool isLoading = false})
    : this._(status: CastVoteStatus.voted, topic: topic, isLoading: isLoading);

  const VoteState.error(String errorMessage)
    : this._(
        status: CastVoteStatus.idle,
        errorMessage: errorMessage,
        isLoading: true,
      );
}
