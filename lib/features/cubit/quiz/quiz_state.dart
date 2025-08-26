part of 'quiz_cubit.dart';

@immutable
abstract class QuizState {}

class QuizLoading extends QuizState {}

class QuizInitial extends QuizState {}

class NextQuestionState extends QuizState {
  final String answer;
  NextQuestionState({required this.answer});
}

class PrevQuestionState extends QuizState {
  final String answer;
  PrevQuestionState({required this.answer});
}

class SubmitSucessState extends QuizState {}

class SubmitLoadindState extends QuizState {}

class SubmiterrorsState extends QuizState {}

class QuestionChange extends QuizState {
  final String answer;

  QuestionChange({required this.answer});
}

class OptionsSeletedState extends QuizState {
  final String answer;

  OptionsSeletedState(this.answer);
}

class EnglishQuestionState extends QuizState {}

class HindiQuestionState extends QuizState {}

class GetTimerState extends QuizState {
  final String timeMin;

  GetTimerState({required this.timeMin});
}
