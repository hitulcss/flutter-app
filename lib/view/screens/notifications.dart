// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/api/retrofit_api.dart';
import 'package:sd_campus_app/api/base_model.dart';
import 'package:sd_campus_app/api/network_api.dart';
import 'package:sd_campus_app/api/server_error.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/models/notificationget.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/bottomnav/ncert.dart';
import 'package:sd_campus_app/view/screens/bottomnav/quiz/quiz_list.dart';
import 'package:sd_campus_app/view/screens/home.dart';
import 'package:sd_campus_app/view/screens/sidenav/mycourses.dart';
import 'package:sd_campus_app/view/screens/sidenav/myschedule.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/airresourcesscreen.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/course_index_resources.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/dailynews.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/samplenotes.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/shortnotes.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationGetData> notificationData = [];

  bool isloading = true;

  @override
  void initState() {
    analytics.logScreenView(
      screenName: "app_Notification",
      screenClass: "NotificationScreen",
    );
    callApinotication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset('assets/images/Notification_bg_cicle.png'),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/Notification_bg_cicle.png',
                color: ColorResources.buttoncolor.withValues(alpha: 0.3),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          Languages.notification,
                          style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack, fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1.5,
                  ),
                  isloading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : notificationData.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    'assets/images/Notification_rectangle.png',
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              width: double.maxFinite,
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.pinkAccent.withValues(alpha: 0.2),
                                    child: Icon(
                                      Icons.notifications_none_outlined,
                                      color: ColorResources.resourcesCardColor,
                                      size: 35,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'No notification',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: notificationData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () async {
                                    Preferences.onLoading(context);
                                    analytics.logEvent(name: "app_nofication_item_click", parameters: {
                                      "route": notificationData[index].route,
                                      "msg": notificationData[index].message,
                                    });
                                    if (await statusupdate(id: notificationData[index].id)) {
                                      if (notificationData[index].route == 'mybatch' || notificationData[index].route == 'classchedule') {
                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (context) => const MyCoursesScreen(),
                                          ),
                                        );
                                      } else if (notificationData[index].route == 'mytestseries' || notificationData[index].route == 'attempttest' || notificationData[index].route == 'testresult') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => const HomeScreen(
                                              index: 2,
                                            ),
                                          ),
                                        );
                                      } else if (notificationData[index].route == 'attemptquiz' || notificationData[index].route == 'quizresult') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const QuizListScreen()),
                                        );
                                      } else if (notificationData[index].route == 'myschedule') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const MySchedule()),
                                        );
                                      } else if (notificationData[index].route == 'air') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const AirResourcesScreen()),
                                        );
                                      } else if (notificationData[index].route == 'news') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const DailyNewsScreen()),
                                        );
                                      } else if (notificationData[index].route == 'courseindex') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const CoursesIndexResources()),
                                        );
                                      } else if (notificationData[index].route == 'shortnotes') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const ShortNotesScreen()),
                                        );
                                      } else if (notificationData[index].route == 'ytnotes') {
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => const NcertScreen(
                                            from: 'note',
                                          ),
                                        ));
                                      } else if (notificationData[index].route == 'samplenotes') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const SampleNotesScreen()),
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage('assets/images/Notification_rectangle.png'),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          spreadRadius: 0,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    child: ListTile(
                                      // leading: Container(
                                      //   decoration: BoxDecoration(
                                      //     shape: BoxShape.circle,
                                      //   ),
                                      //   child: Image.network(
                                      //     SvgImages.avatar,
                                      //     height: 45,
                                      //   ),
                                      // ),
                                      horizontalTitleGap: 4,
                                      title: Text(
                                        notificationData[index].message,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      subtitle: Text(
                                        notificationData[index].createdAt, // ${DateFormat.jms().format(DateFormat('hh:mm:ss').parse(notificationData[index].createdAt!.split(' ')[1]).toLocal()).toString()}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<BaseModel<NotificationGet>> callApinotication() async {
    NotificationGet response;
    try {
      var token = SharedPreferenceHelper.getString(Preferences.accesstoken);
      response = await RestClient(RetroApi().dioData(token!)).getnotificationRequest();
      safeSetState(() {
        notificationData = response.data;
        // notificationData.sort((a, b) {
        //   //print(a.createdAt);
        //   return DateFormat('dd-MM-yyyy')
        //       .parse(a.createdAt!.split(" ")[0])
        //       .compareTo(
        //           DateFormat("dd-MM-yyyy").parse(b.createdAt!.split(" ")[0]));
        // });
        isloading = false;
      });
    } catch (error) {
      // print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<bool> statusupdate({required String id}) async {
    // print(id);
    var response = await RemoteDataSourceImpl().notificationread(id: id);
    Preferences.hideDialog(context);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
