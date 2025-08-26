import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitial());
  Map answerarr = <String, String>{};
  int questionNumber = 1;
  String getTimeQuiz = '0';

  void init(
    int numberofques,
  ) {
    for (var i = 1; i < numberofques + 1; i++) {
      answerarr[i.toString()] = "";
    }
  }

  void nextquestion(String answer) {
    questionNumber++;
    // print(questionNumber);
    emit(NextQuestionState(answer: answerarr[questionNumber.toString()]!));
  }

  void prevquestion() {
    questionNumber--;
    // print(answerarr[questionNumber.toString()]);
    emit(PrevQuestionState(answer: answerarr[questionNumber.toString()]!));
  }

  void selectquestion({required int number}) {
    questionNumber = number;
    emit(QuestionChange(answer: answerarr[questionNumber.toString()]!));
  }

  void selectedoption(answer) {
    // print(answerarr);
    answerarr[questionNumber.toString()] = answer;
    emit(OptionsSeletedState(answer));
  }

  Future<bool> submitQuizobjective({required testid}) async {
    emit(QuizLoading());
    Response response = await RemoteDataSourceImpl().submitobjtestlive(testid, answerarr);
    // print(response);
    if (response.data['status']) {
      emit(SubmitSucessState());
      flutterToast(response.data['msg']);
      return true;
    } else {
      flutterToast(response.data['msg']);
      emit(SubmiterrorsState());
      return false;
    }
  }

  Future<bool> submitResumeQuizobjective({required String testid, }) async {
    emit(QuizLoading());
    Response response = await RemoteDataSourceImpl().submitresumequizrequest(testid, answerarr, getTimeQuiz);
    // print(response);
    if (response.data['status']) {
      emit(SubmitSucessState());
      flutterToast(response.data['msg']);
      return true;
    } else {
      flutterToast(response.data['msg']);
      emit(SubmiterrorsState());
      return false;
    }
  }

  void submitQuiz({required String testid}) async {
    // print(answerarr);
    // print(testid);
    emit(SubmitLoadindState());
    Response response = await RemoteDataSourceImpl().submittquizrequest(testid, answerarr, getTimeQuiz);
    // print(response);
    if (response.statusCode == 200) {
      emit(SubmitSucessState());
      flutterToast(response.data['msg']);
    } else {
      flutterToast(response.data['msg']);
      emit(SubmiterrorsState());
    }
  }

  void englishlanguage() {
    emit(EnglishQuestionState());
  }

  void hindilanguage() {
    emit(HindiQuestionState());
  }

  void getTimer(String timerMin) {
    getTimeQuiz = timerMin;
    emit(GetTimerState(timeMin: timerMin));
  }
}
