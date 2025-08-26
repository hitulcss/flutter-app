import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/models/library/get_quiz_question_library.dart';

part 'quiz_library_state.dart';

class QuizLibraryCubit extends Cubit<QuizLibraryState> {
  QuizLibraryCubit() : super(QuizLibraryInitial());
  Map answerarr = <String, String>{};
  int questionNumber = 1;
  String selectedCatagory = "";
  String getTimeQuiz = '0';
  Map<String, List<int>> catagory = {};
  void init(
    int numberofques,
  ) {
    for (var i = 1; i < numberofques + 1; i++) {
      answerarr[i.toString()] = "";
    }
  }

  int attempted() {
    log(answerarr.values.toString());
    return answerarr.values.where((element) => element.isNotEmpty).length;
  }

  Map<String, List<int>> getCatagory({required List<GetQuizQuestionLibraryData> getQuizQuestionLibraryData}) {
    catagory.clear();
    for (var i = 0; i < getQuizQuestionLibraryData.length; i++) {
      if (catagory.containsKey(getQuizQuestionLibraryData.elementAt(i).sectionId?.title)) {
        catagory.update(
            getQuizQuestionLibraryData.elementAt(i).sectionId?.title ?? "",
            (value) => [
                  ...value,
                  i
                ]);
      } else {
        catagory.putIfAbsent(
            getQuizQuestionLibraryData.elementAt(i).sectionId?.title ?? "",
            () => [
                  i
                ]);
      }
    }
    catagory.removeWhere((key, value) => value.isEmpty);
    return catagory;
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
    log(questionNumber.toString());
    emit(QuestionChange(answer: answerarr[questionNumber.toString()]!));
  }

  void selectedoption(answer) {
    // print(answerarr);
    answerarr[questionNumber.toString()] = answer;
    emit(OptionsSeletedState(answer));
  }

  // Future<bool> submitQuizobjective({required testid}) async {
  //   emit(QuizLoading());
  //   Response response = await RemoteDataSourceImpl().submitobjtestlive(testid, answerarr);
  //   // print(response);
  //   if (response.data['status']) {
  //     emit(SubmitSucessState());
  //     flutterToast(response.data['msg']);
  //     return true;
  //   } else {
  //     flutterToast(response.data['msg']);
  //     emit(SubmiterrorsState());
  //     return false;
  //   }
  // }

  // Future<bool> submitResumeQuizobjective({required String testid, }) async {
  //   emit(QuizLoading());
  //   Response response = await RemoteDataSourceImpl().submitresumequizrequest(testid, answerarr, getTimeQuiz);
  //   // print(response);
  //   if (response.data['status']) {
  //     emit(SubmitSucessState());
  //     flutterToast(response.data['msg']);
  //     return true;
  //   } else {
  //     flutterToast(response.data['msg']);
  //     emit(SubmiterrorsState());
  //     return false;
  //   }
  // }

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

  void seletedCatagory({required String catagory}) {
    selectedCatagory = catagory;
    emit(QuizLibraryInitial());
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
