part of 'livestream_quiz_cubit.dart';

sealed class LivestreamQuizState extends Equatable {
  const LivestreamQuizState();

  @override
  List<Object> get props => [];
}

final class LivestreamQuizInitial extends LivestreamQuizState {}

class MediasoupPollData extends LivestreamQuizState {}
class MediasoupPollCompleted extends LivestreamQuizState {}
