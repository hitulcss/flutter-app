// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/scheduler_data_source/scheduler_remote_data_source_impl.dart';
import 'package:sd_campus_app/features/domain/reused_function.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as lad;

import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';

class MyScheduleAdd extends StatefulWidget {
  const MyScheduleAdd({super.key});

  @override
  State<MyScheduleAdd> createState() => _MyScheduleAddState();
}

class _MyScheduleAddState extends State<MyScheduleAdd> {
  DateTime selectDate = DateTime.now();
  DateTime focuseDate = DateTime.now();
  var hours = [
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12"
  ];
  var min = [
    "00",
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30",
    "31",
    "32",
    "33",
    "34",
    "35",
    "36",
    "37",
    "38",
    "39",
    "40",
    "41",
    "42",
    "43",
    "44",
    "45",
    "46",
    "47",
    "48",
    "49",
    "50",
    "51",
    "52",
    "53",
    "54",
    "55",
    "56",
    "57",
    "58",
    "59",
    "60"
  ];
  var aMPM = [
    "AM",
    "PM",
  ];
  int addtaskcount = 1;

  String? selectedhour;

  String? selectedmin;

  String selectedAMPM = 'AM';

  // final _iseveryday = false;

  String task = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          Preferences.appString.myschedule ?? Languages.mySchedule,
          style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Preferences.appString.selectDate ?? Languages.selectDate,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: ColorResources.gray),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(1954, 10, 16),
                lastDay: DateTime.utc(2159, 10, 16),
                calendarStyle: CalendarStyle(
                  weekendTextStyle: GoogleFonts.notoSansDevanagari(color: Colors.red),
                  selectedDecoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  selectedTextStyle: GoogleFonts.notoSansDevanagari(color: ColorResources.textWhite),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) {
                  return isSameDay(selectDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  safeSetState(() {
                    selectDate = selectedDay;
                    focuseDate = focusedDay; // update `_focusedDay` here as well
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: ColorResources.gray),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    Preferences.appString.scheduleDetails ?? Languages.scheduleDetails,
                    style: GoogleFonts.notoSansDevanagari(),
                  ),
                  TextField(
                    onChanged: (value) {
                      task = value;
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorResources.gray, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorResources.gray, width: 1.0),
                      ),
                      hintText: Languages.task,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: ColorResources.gray),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Preferences.appString.notifyAt ?? Languages.notifyAt,
                          style: GoogleFonts.notoSansDevanagari(),
                        ),
                        Row(
                          children: [
                            DropdownButton(
                              hint: const Text('HH'),
                              value: selectedhour,
                              items: hours.map((String hours) {
                                return DropdownMenuItem(
                                  value: hours,
                                  child: Text(hours),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                safeSetState(() {
                                  selectedhour = newValue.toString();
                                  // print(newValue);
                                });
                              },
                            ),
                            DropdownButton(
                              hint: const Text("MM"),
                              value: selectedmin,
                              items: min.map((String hours) {
                                return DropdownMenuItem(
                                  value: hours,
                                  child: Text(hours),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                safeSetState(() {
                                  selectedmin = newValue.toString();
                                  // print(newValue);
                                });
                              },
                            ),
                            DropdownButton(
                              hint: const Text("AM"),
                              value: selectedAMPM,
                              items: aMPM.map((String hours) {
                                return DropdownMenuItem(
                                  value: hours,
                                  child: Text(hours),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                safeSetState(() {
                                  selectedAMPM = newValue.toString();
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //       onPressed: () {
                  //         safeSetState(() {
                  //           addtaskcount = addtaskcount + 1;
                  //         });
                  //       },
                  //       child: Text(
                  //         Languages.addTask,
                  //         style: GoogleFonts.notoSansDevanagari(
                  //           color: ColorResources.buttoncolor,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       )),
                  // )
                ],
              ),
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorResources.buttoncolor,
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                // print(selectDate.toString().split(' ')[0]);
                if (task.isNotEmpty && selectedhour != null && selectedmin != null) {
                  // print("${DateFormat("dd-MM-yyyy").format(selectDate).toString().split(' ').first} $selectedhour:$selectedmin $selectedAMPM");
                  _addSchedular(task, "${DateFormat("dd-MM-yyyy").format(selectDate).toString().split(' ').first} $selectedhour:$selectedmin $selectedAMPM");
                } else {
                  flutterToast('Select All the fields');
                }
              },
              child: Text(
                Preferences.appString.setAlarm ?? Languages.createdFor,
                style: TextStyle(
                  color: ColorResources.textWhite,
                ),
              ) // ${DateFormat('MMMM dd').format(selectDate)}'),
              ),
        ]),
      ),
    );
  }

  void _addSchedular(String task, String time) async {
    // print(time);
    final schedulerRemoteDataSourceImpl = SchedulerRemoteDataSourceImpl();
    lad.initializeTimeZones();
    try {
      // Android initialization
      AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

      // ios initialization
      DarwinInitializationSettings initializationSettingsIOS = const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
      final notifcation = FlutterLocalNotificationsPlugin();
      await notifcation.initialize(initializationSettings);
      Preferences.onLoading(context);
      Response response = await schedulerRemoteDataSourceImpl.addSchedule(task, time);
      if (response.statusCode == 200) {
        Preferences.hideDialog(context);
        if (response.data['status']) {
          lad.initializeTimeZones();
          final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
            DateFormat('dd-MM-yyyy KK:mm a').parse(time),
            tz.local,
          );
          if (DateFormat('dd-MM-yyyy KK:mm a').parse(time).difference(DateTime.now()).inSeconds >= 1) {
            await notifcation.zonedSchedule(
              0,
              task,
              " ",
              scheduledDate,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
              const NotificationDetails(
                  android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                icon: "mipmap/ic_launcher",
              )),
              androidScheduleMode: AndroidScheduleMode.alarmClock,
            );
          }
          // zonedSchedule(
          //     0,
          //     task,
          //     " ",
          //     tz.TZDateTime.from(
          //         DateFormat('yyyy-MM-dd KK:mm a').parse(time), tz.local),
          //     const NotificationDetails(
          //         android: AndroidNotificationDetails('high_importance_channel',
          //             'High Importance Notifications',
          //             channelDescription:
          //                 'This channel is used for important notifications.')),
          //     uiLocalNotificationDateInterpretation:
          //         UILocalNotificationDateInterpretation.absoluteTime,
          //     androidAllowWhileIdle: true);
          Navigator.pop(context);
          flutterToast(response.data['msg']);
        } else {
          loginRoute();
        }
      } else {
        Preferences.hideDialog(context);
        flutterToast(response.data['msg']);
      }
    } catch (error) {
      flutterToast('Server Error');
    }
  }
}
