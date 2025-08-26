import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sd_campus_app/features/cubit/appstream_cubit/app_stream_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';
import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart' as myCourses;
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/locked_content_popup.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/models/classschedule.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/app_stream.dart';
import 'package:sd_campus_app/view/screens/live_class/live_class_lecture.dart';
import 'package:sd_campus_app/view/screens/youtubeclass.dart';

class ListOfLectureSubject extends StatelessWidget {
  final String subjectName;
  final String subjectId;
  final String batchId;
  final Data data;
  const ListOfLectureSubject({
    super.key,
    required this.subjectName,
    required this.subjectId,
    required this.batchId,
    required this.data,
  });
  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: "List of Lecture Subject",
      parameters: {
        "subjectName": subjectName,
        "subjectId": subjectId,
        "batchId": batchId,
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(subjectName),
      ),
      body: FutureBuilder(
          future: RemoteDataSourceImpl().getLecturesOfSubjects(batchid: batchId, subjectId: subjectId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return snapshot.data?.data?.isEmpty ?? true
                    ? EmptyWidget(image: SvgImages.emptyCourseVideo, text: Languages.novideo)
                    : ListView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: snapshot.data?.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final lecture = snapshot.data?.data?[index] ?? ClassScheduleModel();
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (lecture.link?.trim().isEmpty ?? true) {
                                  lockedContentPopup(context: context, data: data, place: "Classes");
                                } else {
                                  if (DateFormat("dd-MM-yyyy HH:mm:ss").parse(lecture.startingDate!).difference(DateTime.now()).inDays > 0) {
                                    analytics.logEvent(name: "app_trying_to_attend_class", parameters: {
                                      "lectureTitle": lecture.lectureTitle ?? "",
                                      "Id": lecture.id ?? "",
                                    });
                                    flutterToast('Lecture will start at ${DateFormat("dd MMM yyyy HH:mm a").format(DateFormat("dd-MM-yyyy HH:mm:ss").parse(lecture.startingDate ?? ""))}');
                                  } else {
                                    if (lecture.lectureType == "YT") {
                                      // //print(lecture.link);
                                      if (DateFormat("dd-MM-yyyy HH:mm:ss").parse(lecture.startingDate!).difference(DateTime.now()).inSeconds < 60) {
                                        analytics.logEvent(name: "app_class_attend", parameters: {
                                          "lectureTitle": lecture.lectureTitle ?? "",
                                          "Id": lecture.id ?? "",
                                        });
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => YTClassScreen(
                                              lecture: myCourses.LectureDetails(
                                                sId: lecture.id,
                                                lectureType: lecture.lectureType,
                                                lectureTitle: lecture.lectureTitle,
                                                description: lecture.description,
                                                teacher: null,
                                                subject: myCourses.Subject(sId: lecture.subject),
                                                link: lecture.link,
                                                liveOrRecorded: lecture.link,
                                                startingDate: lecture.startingDate,
                                                endingDate: lecture.endingDate,
                                                material: lecture.material,
                                                batchDetails: lecture.batchDetails,
                                                commonName: lecture.commonName,
                                                socketUrl: lecture.socketUrl,
                                                banner: lecture.banner,
                                                roomDetails: lecture.roomDetails,
                                                ytLiveChatId: lecture.ytLiveChatId,
                                                dpp: lecture.dpp,
                                                language: lecture.language,
                                                isCommentAllowed: lecture.isCommentAllowed,
                                              ),
                                            ),
                                          ),
                                        );
                                        //print("object1");
                                      } else {
                                        analytics.logEvent(name: "app_trying_to_attend_class", parameters: {
                                          "lectureTitle": lecture.lectureTitle ?? "",
                                          "Id": lecture.id ?? "",
                                        });
                                        flutterToast('Lecture will start at ${DateFormat.jm().format(DateFormat("HH:mm:ss").parse(lecture.startingDate?.split(" ").last ?? ""))}');
                                      }
                                    } else if (lecture.lectureType == "TWOWAY") {
                                      // print("object");
                                      // print(lecture.toJson());
                                      // print(lecture.roomDetails?.batchName ?? "");
                                      // print(lecture.roomDetails?.id);
                                      // print(lecture.socketUrl);
                                      // print(lecture.roomDetails?.mentor);
                                      // print(SharedPreferenceHelper.getString(Preferences.accesstoken));
                                      // print(SharedPreferenceHelper.getString(Preferences.name));
                                      [
                                        Permission.camera,
                                        Permission.microphone,
                                        Permission.bluetooth,
                                        Permission.bluetoothConnect
                                      ].request().then((value) async {
                                        if (await Permission.camera.isGranted && await Permission.microphone.isGranted) {
                                          if (DateFormat("dd-MM-yyyy HH:mm:ss").parse(lecture.startingDate!).difference(DateTime.now()).inSeconds < 60) {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => LiveClassLecture(
                                                      lecture: myCourses.LectureDetails(
                                                        sId: lecture.id,
                                                        lectureType: lecture.lectureType,
                                                        lectureTitle: lecture.lectureTitle,
                                                        description: lecture.description,
                                                        teacher: lecture.teacher?.map((e) => myCourses.Teacher(sId: e)).first,
                                                        subject: myCourses.Subject(sId: lecture.subject),
                                                        link: lecture.link,
                                                        liveOrRecorded: lecture.link,
                                                        startingDate: lecture.startingDate,
                                                        endingDate: lecture.endingDate,
                                                        material: lecture.material,
                                                        batchDetails: lecture.batchDetails,
                                                        commonName: lecture.commonName,
                                                        socketUrl: lecture.socketUrl,
                                                        banner: lecture.banner,
                                                        roomDetails: lecture.roomDetails,
                                                        ytLiveChatId: lecture.ytLiveChatId,
                                                        dpp: lecture.dpp,
                                                        language: lecture.language,
                                                        isCommentAllowed: lecture.isCommentAllowed,
                                                      ),
                                                      batch: lecture.roomDetails?.batchName ?? "",
                                                      roomName: lecture.roomDetails?.title ?? "",
                                                      name: SharedPreferenceHelper.getString(Preferences.name)!,
                                                      url: lecture.socketUrl ?? "",
                                                      mentor: lecture.roomDetails?.mentor?.first.mentorName ?? "",
                                                      token: SharedPreferenceHelper.getString(Preferences.accesstoken) ?? "",
                                                    )));
                                          } else {
                                            flutterToast('Lecture will start at ${DateFormat.jm().format(DateFormat("HH:mm:ss").parse(lecture.startingDate?.split(" ").last ?? ''))}');
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content: Text(Preferences.appString.permissionDenied ?? 'Permission Denied'),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(Preferences.appString.close ?? "close")),
                                              ],
                                            ),
                                          );
                                        }
                                      });
                                    } else if (lecture.lectureType == "APP") {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) => AppStreamCubit(),
                                            child: JoinStreamingScreen(
                                              lecture: myCourses.LectureDetails(
                                                sId: lecture.id,
                                                lectureType: lecture.lectureType,
                                                lectureTitle: lecture.lectureTitle,
                                                description: lecture.description,
                                                teacher: lecture.teacher?.map((e) => myCourses.Teacher(sId: e)).first,
                                                subject: myCourses.Subject(sId: lecture.subject),
                                                link: lecture.link,
                                                liveOrRecorded: lecture.link,
                                                startingDate: lecture.startingDate,
                                                endingDate: lecture.endingDate,
                                                material: lecture.material,
                                                batchDetails: lecture.batchDetails,
                                                commonName: lecture.commonName,
                                                socketUrl: lecture.socketUrl,
                                                banner: lecture.banner,
                                                roomDetails: lecture.roomDetails,
                                                ytLiveChatId: lecture.ytLiveChatId,
                                                dpp: lecture.dpp,
                                                language: lecture.language,
                                                isCommentAllowed: lecture.isCommentAllowed,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                      // callApiJoinStreamingScreen(lecture, context);
                                    }
                                  }
                                }
                              },
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                leading: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ImageFiltered(
                                          imageFilter: (DateFormat("dd-MM-yyyy HH:mm:ss").parse(lecture.startingDate!).difference(DateTime.now()).inDays > 0) ? ImageFilter.blur(sigmaX: 3, sigmaY: 3) : ImageFilter.blur(),
                                          child: CachedNetworkImage(
                                            imageUrl: lecture.banner ?? "",
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                          ),
                                        ),
                                      ),
                                      (lecture.link?.trim().isEmpty ?? true)
                                          ? Center(
                                              child: CircleAvatar(
                                                radius: 15,
                                                child: Center(
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.lock,
                                                      color: ColorResources.buttoncolor,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Positioned(
                                              right: 5,
                                              bottom: 5,
                                              child: CircleAvatar(
                                                radius: 10,
                                                child: Center(
                                                  child: CircleAvatar(
                                                      radius: 8,
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.play_circle_fill,
                                                          color: ColorResources.buttoncolor,
                                                          size: 15,
                                                        ),
                                                      )),
                                                ),
                                              )),
                                    ],
                                  ),
                                ),
                                title: Text(
                                  lecture.lectureTitle!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // subtitle:Text('Starts : ${DateFormat("dd-MM-yyyy",'UTC').parse(lecture.startingDate)}'),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "${DateFormat.jm().format(DateFormat("HH:mm:ss").parse(lecture.startingDate.toString().split(" ")[1]))} ",
                                          // ${Languages.to} ${DateFormat.jm().format(DateFormat("HH:mm:ss").parse(lecture.endingDate.toString().split(" ")[1]))}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(DateFormat("dd MMM yyyy").format(DateFormat("dd-MM-yyyy").parse(lecture.startingDate.toString().split(" ")[0]))),
                                      ],
                                    ),
                                  ],
                                ),
                                // trailing: CircleAvatar(
                                //   radius: 25,
                                //   child: Icon(
                                //     Icons.lock_outline_rounded,
                                //     color: ColorResources.buttoncolor,
                                //     size: 35,
                                //   ),
                                // ),
                              ),
                            ),
                          );
                        },
                      );
              } else {
                return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
              }
            } else {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          }),
    );
  }
}
