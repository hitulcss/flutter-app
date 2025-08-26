part of 'quiz_library_cubit.dart';

@immutable
abstract class QuizLibraryState {}

class QuizLibraryLoading extends QuizLibraryState {}

class QuizLibraryInitial extends QuizLibraryState {}

class NextQuestionState extends QuizLibraryState {
  final String answer;
  NextQuestionState({required this.answer});
}

class PrevQuestionState extends QuizLibraryState {
  final String answer;
  PrevQuestionState({required this.answer});
}

class SubmitSucessState extends QuizLibraryState {}

class SubmitLoadindState extends QuizLibraryState {}

class SubmiterrorsState extends QuizLibraryState {}

class QuestionChange extends QuizLibraryState {
  final String answer;

  QuestionChange({required this.answer});
}

class OptionsSeletedState extends QuizLibraryState {
  final String answer;

  OptionsSeletedState(this.answer);
}

class EnglishQuestionState extends QuizLibraryState {}

class HindiQuestionState extends QuizLibraryState {}

class GetTimerState extends QuizLibraryState {
  final String timeMin;

  GetTimerState({required this.timeMin});
}
