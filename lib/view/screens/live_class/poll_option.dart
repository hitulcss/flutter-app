import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sd_campus_app/features/cubit/live_Stream_quiz/livestream_quiz_cubit.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/services/socket_connection.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';

class DynamicRadio extends StatefulWidget {
  final String token;
  const DynamicRadio({
    super.key,
    required this.token,
  });

  @override
  DynamicRadioState createState() => DynamicRadioState();
}

class DynamicRadioState extends State<DynamicRadio> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LivestreamQuizCubit, LivestreamQuizState>(
        builder: (context, state) {
          // print(state);
          if (state is MediasoupPollData) {
            // print(state);
            // print(context.read<LivestreamQuizCubit>().countDownController.getTime());
            return Column(
              children: [
                // Progress bar (using a custom widget)
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Center(
                    child: CircularCountDownTimer(
                      duration: int.parse(context.read<LivestreamQuizCubit>().getpoll.data?.duration ?? '0'),
                      initialDuration: 0,
                      controller: context.read<LivestreamQuizCubit>().countDownController,
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 3,
                      ringColor: Colors.grey[300]!,
                      ringGradient: null,
                      fillColor: Colors.purpleAccent[100]!,
                      fillGradient: null,
                      // backgroundColor: Colors.purple[500],
                      backgroundGradient: null,
                      strokeWidth: 15.0,
                      strokeCap: StrokeCap.round,
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textFormat: CountdownTextFormat.SS,
                      isReverse: true,
                      isReverseAnimation: true,
                      isTimerTextShown: true,
                      autoStart: true,
                      onStart: () {
                        debugPrint('Countdown Started');
                        // context.read<LivestreamQuizCubit>().initialDuration
                      },
                      onComplete: () {
                        debugPrint('Countdown Ended');
                        context.read<LivestreamQuizCubit>().pollcompleted(token: widget.token);
                        if (context.read<LivestreamQuizCubit>().selectedValue.isEmpty) {
                          SocketConnetion.connection.emitWithAck("postResponse", {
                            "token": widget.token,
                            "lectureId": context.read<LivestreamQuizCubit>().getpoll.data?.lectureId,
                            "options": context.read<LivestreamQuizCubit>().selectedValue,
                            "pollId": context.read<LivestreamQuizCubit>().getpoll.data?.pollId,
                            "duration": "0"
                          }, ack: (data) {
                            //
                          });
                        }
                        Fluttertoast.showToast(msg: "Countdown completed successfully");
                      },
                      onChange: (String timeStamp) {
                        // print("*" * 10);
                        // print(timeStamp);
                        // print("*" * 10);
                        // print('Countdown Changed $timeStamp');
                      },
                      timeFormatterFunction: (defaultFormatterFunction, duration) {
                        if (duration.inSeconds == int.parse(context.read<LivestreamQuizCubit>().getpoll.data?.duration ?? "0")) {
                          return "done";
                        } else {
                          return Function.apply(defaultFormatterFunction, [
                            duration
                          ]);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView(
                          shrinkWrap: true,
                          children: context.read<LivestreamQuizCubit>().getpoll.data!.pollType == "single"
                              ? (context
                                      .read<LivestreamQuizCubit>()
                                      .getpoll
                                      .data
                                      ?.options
                                      ?.map(
                                        (element) => RadioListTile.adaptive(
                                          title: Text(element),
                                          // leading: Radio(
                                          value: element,
                                          groupValue: context.read<LivestreamQuizCubit>().selectedValue.isEmpty ? null : context.read<LivestreamQuizCubit>().selectedValue.first,
                                          onChanged: (value) => safeSetState(() {
                                            if (context.read<LivestreamQuizCubit>().selectedValue.isEmpty) {
                                              // print(context.read<LivestreamQuizCubit>().countDownController.getTime());
                                              context.read<LivestreamQuizCubit>().selectedValue.add(value as String);
                                              if (context.read<LivestreamQuizCubit>().selectedValue.isNotEmpty) {
                                                String? time = context.read<LivestreamQuizCubit>().countDownController.getTime();
                                                SocketConnetion.connection.emitWithAck(
                                                    "postResponse",
                                                    {
                                                      "token": widget.token,
                                                      "lectureId": context.read<LivestreamQuizCubit>().getpoll.data?.lectureId,
                                                      "options": context.read<LivestreamQuizCubit>().selectedValue,
                                                      "pollId": context.read<LivestreamQuizCubit>().getpoll.data?.pollId,
                                                      "duration": Duration(seconds: int.parse(time!.split(":").last), minutes: int.parse(time.split(":").first)).inSeconds.toString(),
                                                    },
                                                    ack: (data) {});
                                                Fluttertoast.showToast(msg: "answer slected: ${context.read<LivestreamQuizCubit>().selectedValue.join(",")}");
                                              }
                                            } else {
                                              Fluttertoast.showToast(msg: "answer already selected: ${context.read<LivestreamQuizCubit>().selectedValue.join(",")}");
                                            }
                                          }),
                                          // ),
                                        ),
                                      )
                                      .toList() ??
                                  [])
                              : (context
                                      .read<LivestreamQuizCubit>()
                                      .getpoll
                                      .data
                                      ?.options!
                                      .map((e) => CheckboxListTile(
                                            title: Text(e),
                                            value: context.read<LivestreamQuizCubit>().selectedValue.contains(e),
                                            onChanged: (value) {
                                              safeSetState(() {
                                                if (context.read<LivestreamQuizCubit>().submited) {
                                                  Fluttertoast.showToast(msg: "answer already submitted to ${context.read<LivestreamQuizCubit>().selectedValue.join(",")}");
                                                } else {
                                                  if (context.read<LivestreamQuizCubit>().selectedValue.contains(e)) {
                                                    context.read<LivestreamQuizCubit>().selectedValue.remove(e);
                                                  } else {
                                                    context.read<LivestreamQuizCubit>().selectedValue.add(e);
                                                  }
                                                }

                                                Fluttertoast.showToast(msg: "answer slected: ${context.read<LivestreamQuizCubit>().selectedValue.join(",")}");
                                              });
                                            },
                                          ))
                                      .toList() ??
                                  [])),
                      context.read<LivestreamQuizCubit>().getpoll.data!.pollType != "single"
                          ? ElevatedButton(
                              onPressed: () {
                                context.read<LivestreamQuizCubit>().submited = true;
                                String? time = context.read<LivestreamQuizCubit>().countDownController.getTime();
                                SocketConnetion.connection.emitWithAck(
                                    "postResponse",
                                    {
                                      "token": widget.token,
                                      "lectureId": context.read<LivestreamQuizCubit>().getpoll.data?.lectureId,
                                      "options": context.read<LivestreamQuizCubit>().selectedValue,
                                      "pollId": context.read<LivestreamQuizCubit>().getpoll.data?.pollId,
                                      "duration": Duration(seconds: int.parse(time!.split(":").last), minutes: int.parse(time.split(":").first)).inSeconds.toString(),
                                    },
                                    ack: (data) {});
                              },
                              child: const Text("Submit"),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is MediasoupPollCompleted) {
            // print(context.read<LivestreamQuizCubit>().getLeaderBoard.data?.optionsPercentage);
            return Column(
              children: [
                const Text(
                  "Poll Result",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: context.read<LivestreamQuizCubit>().getLeaderBoard.data?.optionsPercentage?.entries.map((data) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CircularPercentIndicator(
                            radius: 30.0,
                            percent: double.parse(data.value),
                            center: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  data.key,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  data.value,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    height: 0.8,
                                  ),
                                ),
                              ],
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            animation: true,
                            backgroundColor: Colors.grey,
                            progressColor: Colors.blue,
                          ),
                        );
                      }).toList() ??
                      [],
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.purple[400],
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rank",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Name",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Time",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.separated(
                  itemCount: context.read<LivestreamQuizCubit>().getLeaderBoard.data?.leaderBoard?.length ?? 0,
                  separatorBuilder: (context, index) => const Divider(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(context.read<LivestreamQuizCubit>().getLeaderBoard.data?.leaderBoard?[index].rank.toString() ?? ""),
                          Text(context.read<LivestreamQuizCubit>().getLeaderBoard.data?.leaderBoard?[index].name.toString() ?? ""),
                          Text(context.read<LivestreamQuizCubit>().getLeaderBoard.data?.leaderBoard?[index].duration.toString() ?? ""),
                        ],
                      ),
                    );
                  },
                )),
              ],
            );
          } else {
            return Center(
                child: EmptyWidget(
              image: SvgImages.noPollEmpty,
              text: "There are no polls available.",
            ));
          }
        },
      ),
    );
  }
}
