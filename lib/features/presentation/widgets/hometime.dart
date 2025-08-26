import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/view/screens/timer/timeropen.dart';

class Hometimerwidget extends StatefulWidget {
  final int timeinsec;
  final TextStyle? style;
  const Hometimerwidget({
    super.key,
    required this.timeinsec,
    required this.style,
  });

  @override
  State<Hometimerwidget> createState() => _HometimerwidgetState();
}

class _HometimerwidgetState extends State<Hometimerwidget> {
  Timer? countdownTimer;
  Duration? myDuration;
  int timeinsec = 0;
  Stopwatch stopwatch = Stopwatch();
  @override
  void initState() {
    timeinsec = widget.timeinsec;
    myDuration = Duration(seconds: timeinsec);
    startTimer(context);
    super.initState();
  }

  @override
  void dispose() {
    countdownTimer!.cancel();
    super.dispose();
  }

  void startTimer(BuildContext context) {
    // BlocProvider.of<HometimerCubit>(context)
    //     .timercheck(val: myDuration!.inSeconds);
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    safeSetState(() {
      final seconds = myDuration!.inSeconds + reduceSecondsBy;
      // if (seconds < 0) {
      //   BlocProvider.of<HometimerCubit>(context).timercheck(val: 0);
      //   countdownTimer!.cancel();
      // } else {
      myDuration = Duration(seconds: seconds);
      //}
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(myDuration!.inHours.remainder(24));
    final minutes = strDigits(myDuration!.inMinutes.remainder(60));
    final seconds = strDigits(myDuration!.inSeconds.remainder(60));
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => OpenTimerScreen(
              time: myDuration!.inMilliseconds,
              // allalarmname: SharedPreferenceHelper.getString(
              //     Preferences.selectedtimename)!,
            ),
          ),
        );
        myDuration!.inSeconds;
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: ColorResources.buttoncolor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_sharp,
                size: 18,
                color: ColorResources.buttoncolor,
              ),
              const SizedBox(
                width: 3,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  '$hours:$minutes:$seconds',
                  style: widget.style,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
