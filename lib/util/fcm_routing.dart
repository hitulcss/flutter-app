import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sd_campus_app/features/cubit/appstream_cubit/app_stream_cubit.dart';
import 'package:sd_campus_app/features/cubit/streamselect/streamsetect_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/cus_player.dart';
import 'package:sd_campus_app/util/enum/batch_feature.dart';
import 'package:sd_campus_app/util/enum/playertype.dart';
import 'package:sd_campus_app/util/enum/short_type.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/Community/post_detail.dart';
import 'package:sd_campus_app/view/screens/app_stream.dart';
import 'package:sd_campus_app/view/screens/bottomnav/coursesdetails.dart';
import 'package:sd_campus_app/view/screens/bottomnav/ncert.dart';
import 'package:sd_campus_app/view/screens/bottomnav/quiz/quiz_list.dart';
import 'package:sd_campus_app/view/screens/bottomnav/scholarship_test.dart';
import 'package:sd_campus_app/view/screens/course/community/community_post_detail.dart';
import 'package:sd_campus_app/view/screens/course/community/community_tab.dart';
import 'package:sd_campus_app/view/screens/course/courseview.dart';
import 'package:sd_campus_app/view/screens/course/doubt/doubt_details.dart';
import 'package:sd_campus_app/view/screens/course/doubt/doubts_tab.dart';
import 'package:sd_campus_app/view/screens/e_book/ebookdetail.dart';
import 'package:sd_campus_app/view/screens/e_book/my_e_book/myebookscreen.dart';
import 'package:sd_campus_app/view/screens/home.dart';
import 'package:sd_campus_app/view/screens/live_class/live_class_lecture.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/profile_reel.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/saved_reels.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/short_learning.dart';
import 'package:sd_campus_app/view/screens/sidenav/mycourses.dart';
import 'package:sd_campus_app/view/screens/sidenav/myschedule.dart';
import 'package:sd_campus_app/view/screens/sidenav/mytest.dart';
import 'package:sd_campus_app/view/screens/sidenav/refer/refer_and_earn.dart';
import 'package:sd_campus_app/view/screens/sidenav/refer/wallet.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/airresourcesscreen.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/course_index_resources.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/dailynews.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/samplenotes.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/shortnotes.dart';
import 'package:sd_campus_app/view/screens/sidenav/test_screen/test_detail_screen.dart';
import 'package:sd_campus_app/view/screens/store/store_home.dart';
import 'package:sd_campus_app/view/screens/store/store_product_desc.dart';
import 'package:sd_campus_app/view/screens/youtubeclass.dart';
import 'package:url_launcher/url_launcher.dart';

fcmRouting({required BuildContext context, required RemoteMessage message}) {
  if (message.data.containsKey('route')) {
    if (message.data['route'] == 'mybatch') {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => const MyCoursesScreen(),
        ),
      );
    } else if (message.data['route'] == 'mybatchbyid' || message.data['route'] == 'mybatchNotesById' || message.data['route'] == 'mybatchVideoByid' || message.data['route'] == "announceBatchbyid") {
      //print("object");
      if (message.data["rootId"] != null) {
        //print("object1");
        message.data["rootId"].toString().isNotEmpty
            ? RemoteDataSourceImpl().getMyCoursesByid(id: message.data["rootId"]).then((value) {
                //print(value.toJson());
                //print(value.batchDetails!.toJson());
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => CourseViewScreen(
                      batchId: value.batchId ?? "",
                      courseName: value.batchName ?? "",
                      index: message.data['route'] == "announceBatchbyid"
                          ? BatchFeatureEnum.announcement
                          : message.data['route'] == 'mybatchNotesById'
                              ? BatchFeatureEnum.lecture
                              : message.data['route'] == 'mybatchVideoByid'
                                  ? BatchFeatureEnum.lecture
                                  : BatchFeatureEnum.lecture,
                    ),
                  ),
                );
              }).onError((error, stackTrace) {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const MyCoursesScreen(),
                  ),
                );
              })
            : Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const MyCoursesScreen(),
                ),
              );
      } else {
        //print("object2");
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => const MyCoursesScreen(),
          ),
        );
      }
    } else if (message.data['route'] == "openLink") {
      launchUrl(Uri.parse(message.data['linkUrl'].toString()), mode: LaunchMode.externalApplication);
    } else if (message.data['route'] == "batch") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(
            index: 1,
          ),
        ),
      );
    } else if (message.data["route"] == "lectureById") {
      RemoteDataSourceImpl().getMyCoursesLectureByid(id: message.data["rootId"]).then((value) {
        if (value.lectureType == "YT") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => YTClassScreen(
                lecture: value,
              ),
            ),
          );
        } else if (value.lectureType == "TWOWAY") {
          // print("object");
          // print(value.toJson());
          // // print(widget.name);
          // print(value.roomDetails?.id);
          // print(value.socketUrl);
          // print(value.roomDetails?.mentor?.first.mentorName);
          // print(SharedPreferenceHelper.getString(Preferences.accesstoken));
          // print(SharedPreferenceHelper.getString(Preferences.name));
          [
            Permission.camera,
            Permission.microphone,
            Permission.bluetooth,
            Permission.bluetoothConnect
          ].request();
          // if (DateFormat("dd-MM-yyyy HH:mm:ss").parse(lecture.startingDate!).difference(DateTime.now()).inSeconds < 60) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LiveClassLecture(
                    lecture: value,
                    batch: "not available",
                    roomName: value.roomDetails?.id ?? "",
                    name: SharedPreferenceHelper.getString(Preferences.name)!,
                    url: value.socketUrl ?? "",
                    mentor: value.roomDetails?.mentor?.first.mentorName ?? "",
                    token: SharedPreferenceHelper.getString(Preferences.accesstoken) ?? "",
                  )));
          // }
        } else if (value.lectureType == "APP") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => AppStreamCubit(),
              child: JoinStreamingScreen(lecture: value),
            ),
          ));
        }
      });
    } else if (message.data["route"] == "batchbyid") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CoursesDetailsScreens(
            courseId: message.data["rootId"],
          ),
        ),
      );
    } else if (message.data['route'] == "feed") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(
            index: 2,
          ),
        ),
      );
    } else if (message.data["route"] == "feedById") {
      RemoteDataSourceImpl().getPostsbyidRequest(id: message.data["rootId"]).then((value) {
        if (value.status!) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(
                postdetail: value,
              ),
            ),
          );
        }
      });
    }
    // else if (message.data['route'] == 'mytestseries' || message.data['route'] == 'attempttest' || message.data['route'] == 'testresult') {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => const HomeScreen(
    //         index: 2,
    //       ),
    //     ),
    //   );
    // }
    else if (message.data["route"] == "mytestseriesbyid") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TestSeries(
            id: message.data["rootId"],
          ),
        ),
      );
    } else if (message.data['route'] == "mytestseriesTestid") {
      if (message.data["childId"] != null) {
        message.data["childId"].toString().isNotEmpty
            ? RemoteDataSourceImpl().getMyTestsdetailsbyid(id: message.data["childId"]).then((value) {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                      builder: (context) => TestDetailsScreen(
                            data: value,
                          )),
                );
              }).onError((error, stackTrace) {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => TestSeries(
                      id: message.data["rootId"],
                    ),
                  ),
                );
              })
            : Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => TestSeries(
                    id: message.data["rootId"],
                  ),
                ),
              );
      }
    } else if (message.data['route'] == "mytestseriesTestid") {
      if (message.data["childId"] != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ScholarshipTestScreen(
                  id: message.data["rootId"],
                )));
      }
    } else if (message.data['route'] == "batchDoubt") {
      if (message.data["rootId"] != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DoubtsTabWidgetScreen(
                  batchId: message.data["rootId"],
                  isFullScreen: true,
                  isLocked: false,
                )));
      }
    } else if (message.data['route'] == "batchDoubtById") {
      if (message.data["rootId"] != null && message.data["childId"] != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DoubtPostDetailScreen(
                  batchId: message.data["rootId"],
                  postid: message.data["childId"],
                  isMyDoubt: false,
                )));
      }
    } else if (message.data['route'] == "batchCommunity") {
      if (message.data["rootId"] != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CommunityTabWidgetScreen(
                  batchId: message.data["rootId"],
                  isFullScreen: true,
                  isLocked: false,
                )));
      }
    } else if (message.data['route'] == "batchCommunityById") {
      if (message.data["rootId"] != null && message.data["childId"] != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CommunityPostDetailScreen(
                  batchId: message.data["rootId"],
                  postid: message.data["childId"],
                  isMyCommunity: false,
                )));
      }
    } else if (message.data['route'] == "dailyQuiz") {
      //|| message.data['route'] == 'attemptquiz' || message.data['route'] == 'quizresult') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const QuizListScreen()),
      );
    } else if (message.data['route'] == 'myschedule' || message.data['route'] == "classchedule") {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MySchedule()),
      );
    } else if (message.data['route'] == 'air') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const AirResourcesScreen()),
      );
    } else if (message.data['route'] == 'news') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const DailyNewsScreen()),
      );
    } else if (message.data['route'] == 'syllabus') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CoursesIndexResources()),
      );
    } else if (message.data['route'] == 'pyqs') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ShortNotesScreen()),
      );
    } else if (message.data['route'] == 'ytvideos') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const NcertScreen(
          from: 'note',
        ),
      ));
    } else if (message.data['route'] == 'ytvideosbyid') {
      RemoteDataSourceImpl().getYouTubeVideobyid(id: message.data["rootId"]).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CuPlayerScreen(
                    url: value.videoUrl,
                    isLive: false,
                    playerType: PlayerType.youtube,
                    canpop: false,
                    autoPLay: true,
                    children: const [],
                  )
              // PodPlayerScreen(
              //   youtubeUrl: extractYouTubeVideolink(value.videoUrl) ?? "",
              //   isWidget: false,
              // )
              //  YoutubePlayerWidget(
              //   videoId: videoId,
              // ),
              ),
        );
      });
    } else if (message.data['route'] == 'ncertNotes') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const SampleNotesScreen()),
      );
    } else if (message.data['route'] == 'referandEarn') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ReferEranScreen()),
      );
    } else if (message.data['route'] == 'myWallet') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MyWalletSceen()),
      );
    } else if (message.data['route'] == "quicklearningSaved") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SavedReelsScreen(),
        ),
      );
    } else if (message.data['route'] == "quicklearning") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShortLearningScreen(shortType: ShortType.feed),
        ),
      );
    } else if (message.data['route'] == "quicklearningById") {
      if (message.data["rootId"] != null) {
        RemoteDataSourceImpl().getShortVideosDetails(shortId: message.data["rootId"]).then((value) {
          if (value.id == message.data["rootId"]) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShortLearningScreen(
                      shorts: [
                        value
                      ],
                      shortType: ShortType.feed,
                    )));
          }
        });
      }
    } else if (message.data['route'] == "quicklearningChannel") {
      if (message.data["rootId"] != null) {
        RemoteDataSourceImpl().getShortVideosDetails(shortId: message.data["rootId"]).then((value) {
          if (value.id == message.data["rootId"]) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileReelScreen(
                  channelId: message.data["rootId"],
                ),
              ),
            );
          }
        });
      }
    } else if (message.data['route'] == 'store') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const StoreHomeScreen()),
      );
    } else if (message.data['route'] == 'productByID') {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => StroeProductDescScreen(
                  id: message.data["rootId"],
                )),
      );
    } else if (message.data['route'] == 'storeCatagorybyid') {
      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (context) =>  StoreCategoryScreen(id: message.data["rootId"],)),
      // );
    } else if (message.data['route'] == 'storeOrder') {
      context.read<StreamsetectCubit>().onItemTapped(2);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const StoreHomeScreen()),
      );
    } else if (message.data['route'] == 'ebookbyid') {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => EBookDetailScreen(
                  id: message.data["rootId"],
                )),
      );
    } else if (message.data['route'] == 'ebook') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const HomeScreen(
                  index: 3,
                )),
      );
    } else if (message.data['route'] == 'myebook') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MyEbookScreen()),
      );
    }
  }
}
