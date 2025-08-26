// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:sd_campus_app/features/cubit/hometimer/hometimer_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/timer/addtimer.dart';

class OpenTimerScreen extends StatefulWidget {
  final int time;
  //final String allalarmname;
  const OpenTimerScreen({
    super.key,
    required this.time,
    //required this.allalarmname,
  });

  @override
  State<OpenTimerScreen> createState() => _OpenTimerScreenState();
}

class _OpenTimerScreenState extends State<OpenTimerScreen> {
  final _isHours = true;
  TextEditingController timenamecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    //onChange: (value) => print('onChange $value'),
    //onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    //onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
    onStopped: () {
      // print('onStop');
    },
    onEnded: () {
      // print('onEnded');
    },
  );
  @override
  void initState() {
    super.initState();
    analytics.logScreenView(
      screenName: "app_timer",
      screenClass: "app_openTimer",
    );
    // _stopWatchTimer.rawTime.listen((value) =>
    //     print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    // _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    // _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    //_stopWatchTimer.records.listen((value) => print('records $value'));
    // _stopWatchTimer.fetchStopped.listen((value) => print('stopped from stream'));
    // _stopWatchTimer.fetchEnded.listen((value) => print('ended from stream'));

    /// Can be set preset time. This case is "00:01.23".
    if (widget.time > 0) {
      _stopWatchTimer.onStartTimer();
    }
    _stopWatchTimer.setPresetTime(mSec: widget.time);
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    timenamecontroller.dispose();
    desccontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorResources.textWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          Languages.timer,
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => const AddTimerScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 5),
              child: Text(
                Languages.viewall,
                style: GoogleFonts.notoSansDevanagari(
                  color: ColorResources.buttoncolor,
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          //Text(widget.allalarmname),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.6,
              width: MediaQuery.of(context).size.width * 0.6,
              child: StreamBuilder<int>(
                stream: _stopWatchTimer.rawTime,
                initialData: _stopWatchTimer.rawTime.value,
                builder: (context, snap) {
                  final value = snap.data!;
                  final displayTime = StopWatchTimer.getDisplayTime(
                    value,
                    hours: _isHours,
                  );
                  return Stack(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.6,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: CircularProgressIndicator(
                          value: 1,
                          strokeWidth: 10.0,
                          color: ColorResources.buttoncolor,
                        ),
                      ),
                      Center(
                        child: Text(
                          displayTime.split('.')[0],
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.buttoncolor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stopWatchTimer.isRunning
                  ? GestureDetector(
                      onTap: () {
                        // print("pause" + "*" * 200);
                        safeSetState(() {
                          _stopWatchTimer.onStopTimer();
                        });
                        BlocProvider.of<HometimerCubit>(context).timercheck(val: 0);
                        // Workmanager()
                        //     .cancelByUniqueName(widget.time.toString());
                        // notifications.cancelAll();
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: ColorResources.gray.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(
                              Icons.pause,
                              color: ColorResources.gray,
                              size: 30,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(Languages.pause)
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        safeSetState(() {
                          if (_stopWatchTimer.isRunning) {
                            // print("res" + "*" * 200);
                            // _stopWatchTimer.onStartTimer();
                            // SharedPreferenceHelper.setInt(
                            //     Preferences.alarmtimeinsec,
                            //     _stopWatchTimer.secondTime.value);
                            // scheduleNotification(
                            //     scheduledTime: time,
                            //     body: 'Time up...... ${widget.allalarmname}',
                            //     title: widget.allalarmname);
                            // //task background
                            // Workmanager().registerOneOffTask(
                            //   time.toString(),
                            //   "timerisset",
                            //   initialDelay: Duration(seconds: time),
                            // );
                            // BlocProvider.of<HometimerCubit>(context)
                            //     .timercheck(val: 1);
                          } else {
                            // print("start" + "*" * 200);
                            SharedPreferenceHelper.setInt(Preferences.alarmtimeinsec, _stopWatchTimer.secondTime.value);
                            BlocProvider.of<HometimerCubit>(context).timercheck(val: 1);
                            _stopWatchTimer.onStartTimer();
                          }
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: ColorResources.buttoncolor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(
                              Icons.play_arrow,
                              color: ColorResources.buttoncolor,
                              size: 30,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            Languages.play,
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.buttoncolor,
                            ),
                          )
                        ],
                      ),
                    ),
              GestureDetector(
                onTap: () {
                  // print(_stopWatchTimer.secondTime.value);
                  if (_stopWatchTimer.secondTime.value > 0) {
                    savetime(time: _stopWatchTimer.secondTime.value.toString());
                  }
                  safeSetState(() {
                    _stopWatchTimer.onResetTimer();
                  });

                  BlocProvider.of<HometimerCubit>(context).timercheck(val: 0);
                  // Workmanager().cancelByUniqueName(widget.time.toString());
                  // notifications.cancelAll();
                  // Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ColorResources.buttoncolor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        Icons.stop,
                        color: ColorResources.buttoncolor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      Languages.quit,
                      style: GoogleFonts.notoSansDevanagari(
                        color: ColorResources.buttoncolor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<bool> savetime({required String time}) async {
    // print(time);
    time = Duration(seconds: int.parse(time)).toString().split(".")[0];
    // GlobalKey<FormState> _form = GlobalKey<FormState>();
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, safeSetState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        Languages.saveTimer,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5,
                    ),
                    child: Text(Languages.duration.trimLeft()),
                  ),
                  TextFormField(
                    initialValue: time.padLeft(4),
                    //controller: timenamecontroller,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: Languages.description,
                      hintStyle: TextStyle(
                        color: ColorResources.gray.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5,
                    ),
                    child: Text(Languages.title),
                  ),
                  TextFormField(
                    maxLength: 25,
                    controller: desccontroller,
                    // validator: ValidationBuilder()
                    //     .maxLength(25)
                    //     .minLength(1)
                    //     .build(),
                    // onChanged: (value) {
                    //   _form.currentState!.validate();
                    // },
                    decoration: InputDecoration(
                      //helperText: "maximum title limit of 25 words.",
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: Languages.description,
                      hintStyle: TextStyle(
                        color: ColorResources.gray.withValues(alpha: 0.5),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      Languages.cancel,
                      style: GoogleFonts.notoSansDevanagari(
                        color: ColorResources.gray,
                      ),
                    ),
                  ),
                  Text(
                    "|",
                    style: TextStyle(color: ColorResources.gray),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (desccontroller.text.isNotEmpty) {
                        Preferences.onLoading(context);
                        // alarmname.add(timenamecontroller.text);
                        Response response = await RemoteDataSourceImpl().postmyTimer(
                          timerTitle: desccontroller.text,
                          timerDuration: time,
                        );
                        if (response.data['status']) {
                          Preferences.hideDialog(context);
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const AddTimerScreen(),
                          ));
                        } else {
                          Preferences.hideDialog(context);
                          flutterToast(response.data["msg"]);
                        }
                      } else {
                        flutterToast("Please Enter Description");
                      }
                    },
                    child: Text(
                      Languages.confirm,
                      style: GoogleFonts.notoSansDevanagari(
                        color: ColorResources.buttoncolor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
