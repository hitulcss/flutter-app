// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sd_campus_app/features/cubit/appstream_cubit/app_stream_cubit.dart';
import 'package:sd_campus_app/features/cubit/mediasoup/mediasoup_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/scheduler_data_source/scheduler_remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';
import 'package:sd_campus_app/features/data/remote/models/my_scheduler_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/models/classschedule.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/app_stream.dart';
import 'package:sd_campus_app/view/screens/live_class/live_class_lecture.dart';
import 'package:sd_campus_app/view/screens/youtubeclass.dart';

class MySchedule extends StatefulWidget {
  const MySchedule({super.key});

  @override
  State<MySchedule> createState() => _MyScheduleState();
}

class _MyScheduleState extends State<MySchedule> {
  String? datetoshow;
  final _dateController = TextEditingController();
  final schedulerRemoteDataSourceImpl = SchedulerRemoteDataSourceImpl();
  List listdata = [];
  List mylistdata = [];
  late Future<MySchedulerModel> getMyScheduleData;
  late Future<ClassSchedulermodel> getClassScheduler;

  @override
  void initState() {
    analytics.logScreenView(
      screenName: "app_my_schedule",
      screenClass: "MySchedule",
    );
    getClassScheduler = schedulerRemoteDataSourceImpl.getMyClassSchedule();
    getMyScheduleData = schedulerRemoteDataSourceImpl.getSchedule();
    super.initState();
    datetoshow = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.textWhite,
          iconTheme: IconThemeData(color: ColorResources.textblack),
          title: Text(
            Preferences.appString.mySchedules ?? Languages.mySchedule,
            style: GoogleFonts.notoSansDevanagari(
              color: ColorResources.textblack,
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              datetoshow == DateFormat('dd-MM-yyyy').format(DateTime.now()) ? "${Preferences.appString.scheduleFor ?? Languages.scheduleForToday} ${Preferences.appString.today ?? "Today"}" : Preferences.appString.scheduleFor ?? "Schedule for",
              style: GoogleFonts.notoSansDevanagari(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            TabBar(
              indicatorColor: ColorResources.buttoncolor,
              labelColor: ColorResources.buttoncolor,
              unselectedLabelColor: ColorResources.textblack.withValues(alpha: 0.6),
              labelStyle: GoogleFonts.notoSansDevanagari(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              onTap: (value) {
                mylistdata.clear();
                listdata.clear();
                if (value == 0) {
                  analytics.logScreenView(screenName: "app_my_schedule");
                } else {
                  analytics.logScreenView(screenName: "app_my_class_schedule");
                }
              },
              tabs: [
                Tab(text: Preferences.appString.myschedule ?? Languages.mySchedule),
                Tab(text: Preferences.appString.classSchedule ?? Languages.classSchedule)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorResources.textWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2100));
                if (pickedDate != null) {
                  analytics.logEvent(name: "app_schedule_of_date", parameters: {
                    "selected_date": pickedDate.toString()
                  });
                  // print(
                  // pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                  // print(
                  // formattedDate); //formatted date output using intl package =>  2021-03-16
                  safeSetState(() {
                    mylistdata.clear();
                    listdata.clear();
                    datetoshow = formattedDate; //set output date to TextField value.
                  });
                } else {}
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('dd-MMMM-yyyy').format(DateFormat('dd-MM-yyyy').parse(datetoshow!)),
                    style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
                  ),
                  Icon(
                    Icons.arrow_drop_down_outlined,
                    color: ColorResources.textblack,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  FutureBuilder<MySchedulerModel>(
                      future: getMyScheduleData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            snapshot.data!.data.sort((a, b) => (a.notifyAt.compareTo(b.notifyAt)));
                            for (var element in snapshot.data!.data) {
                              // print(datetoshow);
                              // print(DateFormat("yyyy-MM-dd")
                              // .parse(element.notifyAt)
                              // .toString()
                              // .split(" ")[0]);
                              if (DateFormat("dd-MM-yyyy").parse(element.notifyAt).toString().split(" ")[0] == DateFormat("dd-MM-yyyy").parse(datetoshow!).toString().split(" ")[0]) {
                                mylistdata.add(element);
                                // print('------found u---------');
                              }
                            }
                            return snapshot.data!.data.isEmpty ? Center(child: EmptyWidget(image: SvgImages.emptyMyScdeule, text: Preferences.appString.noSchedules ?? Languages.noscheduler)) : _mySchedulerWidget(context, snapshot.data!.data);
                          } else if (snapshot.hasError) {
                            return Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.5, width: MediaQuery.of(context).size.width * 0.9, child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found")));
                          } else {
                            return Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.5, width: MediaQuery.of(context).size.width * 0.9, child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"))
                                //Text('Pls Refresh (or) Reopen App'),
                                );
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                  FutureBuilder<ClassSchedulermodel>(
                    future: getClassScheduler,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          snapshot.data!.data!.sort((a, b) => (a.startingDate!.compareTo(b.startingDate!)));
                          for (var element in snapshot.data!.data!) {
                            // print(datetoshow);

                            if (DateFormat("dd-MM-yyyy").parse(element.startingDate!).toString().split(" ")[0] == DateFormat("dd-MM-yyyy").parse(datetoshow!).toString().split(" ")[0]) {
                              listdata.add(element);
                              // print('------found u---------');
                            }
                          }
                          return snapshot.data!.data!.isEmpty ? Center(child: EmptyWidget(image: SvgImages.emptyMyScdeule, text: Preferences.appString.noSchedules ?? Languages.noscheduler)) : _classSchedulerWidget(context, snapshot.data!.data!);
                        } else if (snapshot.hasError) {
                          return Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.5, width: MediaQuery.of(context).size.width * 0.9, child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found")));
                        } else {
                          return Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.5, width: MediaQuery.of(context).size.width * 0.9, child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"))
                              //Text('Pls Refresh (or) Reopen App'),
                              );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('MyScheduleAdd').then((value) {
              mylistdata.clear();
              listdata.clear();
              safeSetState(() {
                getMyScheduleData = schedulerRemoteDataSourceImpl.getSchedule();
              });
            });
          },
          backgroundColor: ColorResources.buttoncolor,
          child: Icon(
            Icons.add,
            color: ColorResources.textWhite,
          ),
        ),
      ),
    );
  }

  Widget _classSchedulerWidget(BuildContext context, List<ClassScheduleModel> schedulerList) {
    //flutterToast("loggedIn:${schedulerList[0].loggedIn}");
    return listdata.isNotEmpty
        ? ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 5,
            ),
            itemCount: listdata.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(8.0),
            itemBuilder: (context, index) => classSchedulerContainerWidget(context: context, schedulerData: listdata[index]),
          )
        : Center(child: EmptyWidget(image: SvgImages.emptyMyScdeule, text: Preferences.appString.noSchedules ?? Languages.noscheduler));
  }

  Widget classSchedulerContainerWidget({required BuildContext context, required ClassScheduleModel schedulerData}) {
    return GestureDetector(
      onTap: () async {
        // print(SharedPreferenceHelper.getString(Preferences.name));
        // //print(
        //     "${lecture.startingDate.toString().split(" ")[0]} ==${DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()}");
        //await [Permission.camera, Permission.microphone].request();
        if (schedulerData.lectureType == "YT" && schedulerData.link != null) {
          if (schedulerData.link?.isNotEmpty ?? false) {
            if (DateFormat("dd-MM-yyyy HH:mm:ss").parse(schedulerData.startingDate ?? "").difference(DateTime.now()).inSeconds < 60) {
              analytics.logEvent(name: "app_class_attend", parameters: {
                "lectureTitle": schedulerData.lectureTitle ?? "",
                "Id": schedulerData.id ?? "",
              });
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => YTClassScreen(
                    lecture: LectureDetails(
                      sId: schedulerData.id,
                      lectureType: schedulerData.lectureType,
                      lectureTitle: schedulerData.lectureTitle,
                      description: schedulerData.description,
                      teacher: schedulerData.teacher?.map((e) => Teacher(sId: e)).first,
                      subject: Subject(sId: schedulerData.subject),
                      link: schedulerData.link,
                      liveOrRecorded: schedulerData.link,
                      startingDate: schedulerData.startingDate,
                      endingDate: schedulerData.endingDate,
                      material: schedulerData.material,
                      batchDetails: schedulerData.batchDetails,
                      commonName: schedulerData.commonName,
                      socketUrl: schedulerData.socketUrl,
                      banner: schedulerData.banner,
                      roomDetails: schedulerData.roomDetails,
                      ytLiveChatId: schedulerData.ytLiveChatId,
                      dpp: schedulerData.dpp,
                      language: schedulerData.language,
                      isCommentAllowed: schedulerData.isCommentAllowed,
                    ),
                  ),
                ),
              );
              //print("object1");
            } else {
              analytics.logEvent(name: "app_trying_to_attend_class", parameters: {
                "lectureTitle": schedulerData.lectureTitle ?? "",
                "Id": schedulerData.id ?? "",
              });
              flutterToast('Lecture will start at ${DateFormat.jm().format(DateFormat("HH:mm:ss").parse(schedulerData.startingDate?.split(" ").last ?? ''))}');
            }
          } else {
            flutterToast('Lecture link is empty');
          }
        } else if (schedulerData.lectureType == "TWOWAY") {
          // print(snapshot.data?[index].toJson());
          // print(snapshot.data?[index].roomDetails?.batchName);
          // print(snapshot.data?[index].roomDetails?.id);
          // print(snapshot.data?[index].socketUrl);
          // print(snapshot.data?[index].roomDetails?.mentor);
          // print(SharedPreferenceHelper.getString(Preferences.accesstoken));
          // print(SharedPreferenceHelper.getString(Preferences.name));
          [
            Permission.camera,
            Permission.microphone,
            Permission.bluetooth,
            Permission.bluetoothConnect
          ].request().then((value) async {
            if (await Permission.camera.isGranted && await Permission.microphone.isGranted) {
              if (DateFormat("dd-MM-yyyy HH:mm:ss").parse(schedulerData.startingDate!).difference(DateTime.now()).inSeconds < 60) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) => MediasoupCubit(),
                          child: LiveClassLecture(
                            lecture: LectureDetails(
                              sId: schedulerData.id,
                              lectureType: schedulerData.lectureType,
                              lectureTitle: schedulerData.lectureTitle,
                              description: schedulerData.description,
                              teacher: schedulerData.teacher?.map((e) => Teacher(sId: e)).first,
                              subject: Subject(sId: schedulerData.subject),
                              link: schedulerData.link,
                              liveOrRecorded: schedulerData.link,
                              startingDate: schedulerData.startingDate,
                              endingDate: schedulerData.endingDate,
                              material: schedulerData.material,
                              batchDetails: schedulerData.batchDetails,
                              commonName: schedulerData.commonName,
                              socketUrl: schedulerData.socketUrl,
                              banner: schedulerData.banner,
                              roomDetails: schedulerData.roomDetails,
                              ytLiveChatId: schedulerData.ytLiveChatId,
                              dpp: schedulerData.dpp,
                              language: schedulerData.language,
                              isCommentAllowed: schedulerData.isCommentAllowed,
                            ),
                            batch: schedulerData.roomDetails?.batchName ?? "",
                            roomName: schedulerData.roomDetails?.title ?? "",
                            name: SharedPreferenceHelper.getString(Preferences.name)!,
                            url: schedulerData.socketUrl ?? "",
                            mentor: schedulerData.roomDetails?.mentor?.first.mentorName ?? "",
                            token: SharedPreferenceHelper.getString(Preferences.accesstoken) ?? "",
                          ),
                        )));
              } else {
                flutterToast('Lecture will start at ${DateFormat.jm().format(DateFormat("HH:mm:ss").parse(schedulerData.startingDate?.split(" ").last ?? ''))}');
              }
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: const Text('Permission Denied'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(Preferences.appString.close ?? "close")),
                  ],
                ),
              );
            }
          });
        } else if (schedulerData.lectureType == "APP") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => AppStreamCubit(),
                child: JoinStreamingScreen(
                  lecture: LectureDetails(
                    sId: schedulerData.id,
                    lectureType: schedulerData.lectureType,
                    lectureTitle: schedulerData.lectureTitle,
                    description: schedulerData.description,
                    teacher: schedulerData.teacher?.map((e) => Teacher(sId: e)).first,
                    subject: Subject(sId: schedulerData.subject),
                    link: schedulerData.link,
                    liveOrRecorded: schedulerData.link,
                    startingDate: schedulerData.startingDate,
                    endingDate: schedulerData.endingDate,
                    material: schedulerData.material,
                    batchDetails: schedulerData.batchDetails,
                    commonName: schedulerData.commonName,
                    socketUrl: schedulerData.socketUrl,
                    banner: schedulerData.banner,
                    roomDetails: schedulerData.roomDetails,
                    ytLiveChatId: schedulerData.ytLiveChatId,
                    dpp: schedulerData.dpp,
                    language: schedulerData.language,
                    isCommentAllowed: schedulerData.isCommentAllowed,
                  ),
                ),
              ),
            ),
          );
        } else {
          flutterToast('Lecture type not found or not supported');
        }
        //Navigator.of(context).pushNamed('joinstreaming');
      },
      child: Container(
        // width: snapshot.data?.length != 1 ? MediaQuery.of(context).size.width * 0.8 : MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ColorResources.buttoncolor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  schedulerData.lectureTitle ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorResources.textblack,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${DateFormat.jm().format(DateFormat("HH:mm:ss").parse(schedulerData.startingDate?.split(" ").last ?? ''))} to ${DateFormat.jm().format(DateFormat("HH:mm:ss").parse(schedulerData.endingDate?.split(" ").last ?? ''))}",
                      style: TextStyle(
                        color: ColorResources.textBlackSec,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     const Icon(
                //       Icons.calendar_month_outlined,
                //       size: 15,
                //     ),
                //     const SizedBox(
                //       width: 5,
                //     ),
                //     Text(
                //       schedulerData.startingDate?.split(" ").first ?? '',
                //       style: TextStyle(
                //         color: ColorResources.textBlackSec,
                //         fontSize: 12,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ],
                // ),
              ]),
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorResources.buttoncolor,
              ),
              child: Row(
                children: [
                  Text(
                    "JOIN",
                    style: TextStyle(color: ColorResources.textWhite),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ColorResources.textWhite.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 13,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _mySchedulerWidget(BuildContext context, List<MySchedulerDataModel> schedulerList) {
    //flutterToast("loggedIn:${schedulerList[0].loggedIn}");
    return mylistdata.isNotEmpty
        ? ListView.builder(
            itemCount: mylistdata.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => schedularContainerWidget(
              context: context,
              schedulerData: mylistdata[index],
            ),
          )
        : Center(child: EmptyWidget(image: SvgImages.emptyMyScdeule, text: Preferences.appString.noSchedules ?? Languages.noscheduler));
  }

  Widget schedularContainerWidget({
    required BuildContext context,
    required MySchedulerDataModel schedulerData,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat("dd MMM yyyy hh:mm a").format(DateFormat("dd-MM-yyyy hh:mm a").parse(schedulerData.notifyAt))),
                  Text(
                    schedulerData.task,
                    style: GoogleFonts.notoSansDevanagari(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      analytics.logEvent(name: "app_user_schedule_update", parameters: {
                        "task": schedulerData.task,
                        "id": schedulerData.id,
                      });
                      updatetask(schedulerData).then((value) {
                        safeSetState(() {
                          getMyScheduleData = schedulerRemoteDataSourceImpl.getSchedule();
                        });
                      });
                    },
                    icon: Icon(
                      Icons.edit,
                      color: ColorResources.edit,
                    )),
                IconButton(
                    onPressed: () {
                      analytics.logEvent(name: "app_user_schedule_delete", parameters: {
                        "task": schedulerData.task,
                      });
                      Preferences.onLoading(context);
                      _deleteScheduler(schedulerData.id);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: ColorResources.delete,
                    ))
              ],
            )
          ],
        ),
        const Divider(),
      ],
    );
  }

  Future<void> updatetask(MySchedulerDataModel scheduler) async {
    List<String> hours = [
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
    List<String> min = [
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
    var aMpM = [
      "AM",
      "PM",
    ];
    String? selectedhour;

    String? selectedmin;

    String selectedAMPM = 'AM';
    String task = "";
    String date = "";
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: StatefulBuilder(builder: (BuildContext context, StateSetter safeSetState) {
            return SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Preferences.appString.scheduleDetails ?? 'Schdeule details',
                    style: GoogleFonts.notoSansDevanagari(),
                  ),
                  TextField(
                    onChanged: (value) {
                      task = value.toString();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorResources.gray, width: 1.0),
                      ),
                      hintText: 'Task',
                    ),
                  ),
                  TextField(
                    controller: _dateController,
                    onChanged: (value) {
                      date = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorResources.gray, width: 1.0),
                      ),
                      hintText: 'Date',
                    ),
                    onTap: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2015),
                        lastDate: DateTime(2025),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          date = DateFormat('dd-MM-yyyy').format(selectedDate);
                          safeSetState(() {
                            _dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
                          });
                        }
                      });
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: ColorResources.gray)),
                    padding: const EdgeInsets.all(10),
                    child: Row(children: [
                      Text(Preferences.appString.notifyAt ?? 'Notify at'),
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
                            items: aMpM.map((String hours) {
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
                    ]),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorResources.buttoncolor,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        String notifyAt = "${selectedhour!}:$selectedmin $selectedAMPM";
                        if (task.isNotEmpty || date.isNotEmpty) {
                          _updateTask(scheduler.id, task, date, notifyAt);
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        Preferences.appString.update ?? 'Update',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  _deleteScheduler(String schedulerId) async {
    final schedulerRemoteDataSourceImpl = SchedulerRemoteDataSourceImpl();
    Response response = await schedulerRemoteDataSourceImpl.deleteScheduler(schedulerId);
    if (response.statusCode == 200) {
      flutterToast(response.data['msg']);
      safeSetState(() {
        mylistdata.clear();
        getMyScheduleData = schedulerRemoteDataSourceImpl.getSchedule();
      });
    } else {
      flutterToast(response.data['msg']);
    }
    Preferences.hideDialog(context);
  }

  void _updateTask(String id, String task, String date, String notifyAt) async {
    Preferences.onLoading(context);
    SchedulerRemoteDataSourceImpl schedulerRemoteDataSourceImpl = SchedulerRemoteDataSourceImpl();
    Response response = await schedulerRemoteDataSourceImpl.updateScheduler(id, task, "$date $notifyAt", isActive: true);
    flutterToast(response.data["msg"]);
    if (response.statusCode == 200) {
      safeSetState(() {
        mylistdata.clear();
        getMyScheduleData = schedulerRemoteDataSourceImpl.getSchedule();
      });
    }
    Preferences.hideDialog(context);
  }
}
