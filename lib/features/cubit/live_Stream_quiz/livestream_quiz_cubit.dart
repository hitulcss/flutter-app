import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sd_campus_app/features/data/remote/models/getlearderbord.dart';
import 'package:sd_campus_app/features/services/socket_connection.dart';
import 'package:sd_campus_app/features/data/remote/models/get_poll.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
part 'livestream_quiz_state.dart';

class LivestreamQuizCubit extends Cubit<LivestreamQuizState> {
  LivestreamQuizCubit() : super(LivestreamQuizInitial());
  List<String> selectedValue = [];
  bool submited = false;
  bool pollsStarted = false;
  int initialDuration = 0;
  int submitedtimer = 0;
  final CountDownController countDownController = CountDownController();
  Getpoll getpoll = Getpoll();
  GetLeaderBoard getLeaderBoard = GetLeaderBoard();
  void pollstarted() {
    pollsStarted = true;
    emit(MediasoupPollData());
  }

  void pollcompleted({required String token}) {
    Future.delayed(const Duration(seconds: 1), () {
      SocketConnetion.connection.emitWithAck("getPollLeaderBoardForUser", {
        "token": token,
        "pollId": getpoll.data?.pollId ?? "",
        "lectureId": getpoll.data?.lectureId ?? "",
      }, ack: (data) {
        // print(data);
        getLeaderBoard = GetLeaderBoard.fromJson(data);
        emit(MediasoupPollCompleted());
      });
    });
  }

  void timercheck() {
    // initialDuration
    Timer.periodic(const Duration(seconds: 1), (timer) {
      initialDuration = initialDuration - 1;
    });
  }
}
