part of 'vote.bloc.dart';

sealed class VoteEvent {}

class MountVoteEvent extends VoteEvent {}

class CastVoteEvent extends VoteEvent {
  final OptionEntity selected;

  CastVoteEvent(this.selected);
}

class CancelVoteEvent extends VoteEvent {}
