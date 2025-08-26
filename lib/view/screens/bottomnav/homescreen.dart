// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sd_campus_app/api/retrofit_api.dart';
import 'package:sd_campus_app/api/base_model.dart';
import 'package:sd_campus_app/api/network_api.dart';
import 'package:sd_campus_app/api/server_error.dart';
import 'package:sd_campus_app/features/cubit/appstream_cubit/app_stream_cubit.dart';
import 'package:sd_campus_app/features/cubit/course_plan/plan_cubit.dart';
import 'package:sd_campus_app/features/cubit/mediasoup/mediasoup_cubit.dart';
import 'package:sd_campus_app/features/cubit/streamselect/streamsetect_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/alertmodel.dart';
import 'package:sd_campus_app/features/data/remote/models/coursesmodel.dart';
import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';
import 'package:sd_campus_app/features/data/remote/models/shorts/get_short_video.dart';
import 'package:sd_campus_app/features/presentation/widgets/app%20tour/tour_next_back_button.dart';
import 'package:sd_campus_app/features/presentation/widgets/course_body_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/demo_player.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/shimmer_custom.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/models/banner.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/short_type.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/lang/banner_lang.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/util/showcase_tour.dart';
import 'package:sd_campus_app/view/screens/app_stream.dart';
import 'package:sd_campus_app/view/screens/bottomnav/course_valdity.dart';
import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart' as coursedetailsmodel;
import 'package:sd_campus_app/view/screens/bottomnav/coursesdetails.dart';
import 'package:sd_campus_app/view/screens/bottomnav/scholarship_test.dart';
import 'package:sd_campus_app/view/screens/course/coursepaymentscreen.dart';
import 'package:sd_campus_app/view/screens/e_book/my_e_book/myebookscreen.dart';
import 'package:sd_campus_app/view/screens/home.dart';
import 'package:sd_campus_app/view/screens/library/library_home.dart';
import 'package:sd_campus_app/view/screens/live_class/live_class_lecture.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/short_learning.dart';
import 'package:sd_campus_app/view/screens/youtubeclass.dart';
import 'package:share_plus/share_plus.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({
    super.key,
  });
  // final VoidCallback onTap;

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  RemoteDataSourceImpl remoteDataSourceImpl = RemoteDataSourceImpl();
  DragController draggableController = DragController();
  bool showDemo = false;
  late Future<MyCoursesModel> myCoursesData;

  @override
  void initState() {
    //   SharedPreferenceHelper.setBoolean(Preferences.awareness, false);
    super.initState();
    // print("dsa");
    // print(SharedPreferenceHelper.getString(Preferences.getCourse));
    analytics.logEvent(name: "app_loggedin_home", parameters: {
      "name": SharedPreferenceHelper.getString(Preferences.name) ?? "Unknown",
      "phoneNumber": SharedPreferenceHelper.getString(Preferences.phoneNUmber) ?? "Unknown",
      "email": SharedPreferenceHelper.getString(Preferences.email) ?? "Unknown",
      "id": SharedPreferenceHelper.getString(Preferences.enrollId) ?? analytics.getSessionId().toString(),
    });

    // myCoursesData = remoteDataSourceImpl.getMyCourses();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        safeSetState(() {
          if (SharedPreferenceHelper.getString(Preferences.demoLink) == Preferences.tutorVideo.link) {
            showDemo = SharedPreferenceHelper.getInt(Preferences.demoClosed) < 3;
          } else {
            SharedPreferenceHelper.setString(Preferences.demoLink, Preferences.tutorVideo.link);
          }
          if (Preferences.tutorVideo.isEnabled ?? false) {
            draggableController.showWidget();
          } else {
            draggableController.hideWidget();
          }
          Future.delayed(const Duration(seconds: 5), () {
            if (mounted) {
              safeSetState(() {});
            }
          });
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RemoteDataSourceImpl remoteDataSourceImpl = RemoteDataSourceImpl();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 2), () {
          analytics.logEvent(name: "refresh");
          safeSetState(() {});
        }),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AspectRatio(aspectRatio: 2.9, child: SliderWidget()),
              if (Preferences.newFeatures.homeShortLearning ?? false) ...[
                SizedBox(
                  height: 5,
                ),
                FutureBuilder(
                    future: RemoteDataSourceImpl().getShortVideos(page: 1, pageSize: 5),
                    builder: (context, psnapshot) {
                      List<Short> savedData = [];
                      if (psnapshot.connectionState == ConnectionState.done && psnapshot.hasData) {
                        savedData = psnapshot.data?.data?.shorts ?? [];

                        return AspectRatio(
                          aspectRatio: 1,
                          child: PageView.builder(
                            itemCount: savedData.length,
                            controller: PageController(
                              viewportFraction: 0.7,
                              initialPage: savedData.length ~/ 2,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              Short data = savedData[index];
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => ShortLearningScreen(
                                          shortType: ShortType.feed,
                                          shorts: savedData,
                                          page: 1,
                                          index: index,
                                        ),
                                      ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          FutureBuilder(
                                              future: VideoThumbnail.thumbnailData(
                                                video: data.urls?.first.url ?? "",
                                                maxHeight: 400,
                                                maxWidth: 900,
                                                quality: 90,
                                              ),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Image.memory(
                                                    snapshot.data!,
                                                    fit: BoxFit.fitWidth,
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Center(
                                                    child: Text("error"),
                                                  );
                                                } else {
                                                  return Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                              }),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            left: 0,
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.black,
                                                    Colors.transparent
                                                  ],
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          data.description ?? "",
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(top: 10, bottom: 10),
                                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ColorResources.buttoncolor.withValues(alpha: 1)),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Iconify(
                                                          Ion.play,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          'Watch now',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              ],
              Preferences.appAlerts.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(height: 10),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.11,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: Preferences.appAlerts.length,
                            itemBuilder: (BuildContext context, int index) {
                              AlertModelData data = Preferences.appAlerts[index];
                              return InkWell(
                                onTap: data.redirectTo?.trim().isNotEmpty ?? false
                                    ? () {
                                        try {
                                          launchUrl(
                                            Uri.parse(data.redirectTo ?? ""),
                                            mode: LaunchMode.externalApplication,
                                          );
                                        } catch (e) {
                                          analytics.logEvent(name: "alert_redirect_error", parameters: {
                                            "error": e.toString(),
                                            "url": data.redirectTo.toString()
                                          });
                                        }
                                      }
                                    : null,
                                child: Container(
                                  width: Preferences.appAlerts.length > 1 ? MediaQuery.of(context).size.width * 0.9 : MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(
                                    left: 15,
                                    top: 2,
                                    bottom: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: data.type == 'information'
                                        ? const Color(0xFFF1F6FD)
                                        : data.type == 'emergency'
                                            ? ColorResources.buttoncolor.withValues(alpha: 0.1)
                                            : const Color(0xFFFCA004).withValues(alpha: 0.1),
                                    border: Border.all(
                                      strokeAlign: BorderSide.strokeAlignOutside,
                                      color: data.type == 'information'
                                          ? const Color(0xFF16A0F9)
                                          : data.type == 'emergency'
                                              ? ColorResources.buttoncolor
                                              : const Color(0xFFFCA004),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.vertical(
                                              top: Radius.circular(10),
                                            ),
                                            color: ColorResources.textWhite),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              data.type == 'information'
                                                  ? const Icon(
                                                      Icons.info_outline_rounded,
                                                      color: Color(0xFF16A0F9),
                                                    )
                                                  : data.type == 'emergency'
                                                      ? Image.asset(
                                                          SvgImages.warning,
                                                          height: 20,
                                                        )
                                                      : const Icon(
                                                          Icons.warning_amber_rounded,
                                                          color: Color(0xFFFFB800),
                                                        ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 5),
                                                  child: Text(
                                                    data.title ?? "",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.notoSansDevanagari(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                      color: data.type == 'information'
                                                          ? const Color(0xFF16A0F9)
                                                          : data.type == 'emergency'
                                                              ? ColorResources.buttoncolor
                                                              : const Color(0xFFFFB800),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                        child: Text(
                                          data.desc ?? "",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.notoSansDevanagari(
                                            fontSize: 14,
                                            color: ColorResources.textblack,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Container(),
              // const SizedBox(height: 10),
              // Container(
              //   height: 100,
              //   color: ColorResources.textWhite,
              //   alignment: Alignment.center,
              //   padding: const EdgeInsets.only(
              //     left: 15,
              //     right: 15,
              //     top: 10,
              //   ),
              //   child: ListView.separated(
              //     itemCount: 6,
              //     shrinkWrap: true,
              //     scrollDirection: Axis.horizontal,
              //     separatorBuilder: (BuildContext context, int index) {
              //       return const SizedBox(
              //         width: 10,
              //       );
              //     },
              //     itemBuilder: (BuildContext context, int index) {
              //       List image = [
              //         SvgImages.dailylive,
              //         SvgImages.dailynews,
              //         SvgImages.syllabus,
              //         SvgImages.emptyvideoh,
              //         SvgImages.pyq,
              //         SvgImages.ncertNotes,
              //       ];
              //       List name = [
              //         'Daily Live',
              //         Languages.dailynews,
              //         Languages.courseIndex,
              //         Languages.youtubevideo,
              //         'PYQs',
              //         Languages.samplenote,
              //       ];
              //       List ontap = [
              //         () => Navigator.of(context).push(MaterialPageRoute(
              //               builder: (context) => const NcertScreen(
              //                 from: 'live',
              //               ),
              //             )),
              //         () => Navigator.of(context).pushNamed('dailynews'),
              //         () => Navigator.of(context).pushNamed('courseIndex'),
              //         () => Navigator.of(context).push(MaterialPageRoute(
              //               builder: (context) => const NcertScreen(
              //                 from: 'note',
              //               ),
              //             )),
              //         () => Navigator.of(context).pushNamed('shortnotes'),
              //         () => Navigator.of(context).pushNamed('samplenotes'),
              //       ];
              //       return quickaccess(image: image[index], name: name[index], ontap: ontap[index]);
              //     },
              //   ),
              // ),
              if (Preferences.newFeatures.scholarshiptest ?? false) ...[
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                    future: RemoteDataSourceImpl().getTestRegistRequest(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return snapshot.data!.data?.isEmpty ?? true
                              ? Container()
                              : snapshot.data!.data!.length == 1
                                  ? GestureDetector(
                                      onTap: () {
                                        analytics.logEvent(name: "app_inerest_in_scholar_test", parameters: {
                                          "test_id": snapshot.data?.data?.first.id ?? "",
                                          "title": snapshot.data?.data?.first.title ?? "",
                                        });
                                        Navigator.of(context).push(CupertinoPageRoute(
                                          builder: (context) => ScholarshipTestScreen(
                                            id: snapshot.data!.data!.first.id!,
                                          ),
                                        ));
                                      },
                                      child: Container(
                                        // constraints: BoxConstraints(maxHeight: 200, maxWidth: MediaQuery.sizeOf(context).width * 0.9),
                                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: ColorResources.textWhite,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0x7FD9D9D9),
                                                blurRadius: 41,
                                                offset: Offset(0, 4),
                                                spreadRadius: 0,
                                              )
                                            ]),
                                        child: Column(
                                          spacing: 10,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                              child: Text(
                                                snapshot.data!.data!.first.title!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: ColorResources.textblack,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  placeholder: (context, url) => const Center(
                                                    child: CircularProgressIndicator(),
                                                  ),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                  imageUrl: snapshot.data!.data!.first.banner!,
                                                  // fit: BoxFit.cover,
                                                  // height: 100,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.calendar_month_outlined,
                                                      size: 15,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      child: Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: '${Preferences.appString.startOn}: ',
                                                              style: TextStyle(
                                                                color: ColorResources.textBlackSec,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: DateFormat("dd MMM yyyy").format(DateFormat("dd-MM-yyyy").parse(snapshot.data!.data!.first.startingAt ?? "")),
                                                              style: TextStyle(
                                                                color: ColorResources.textblack,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: " | ",
                                                              style: TextStyle(color: ColorResources.textBlackSec, fontSize: 10, fontWeight: FontWeight.w400),
                                                            ),
                                                            TextSpan(
                                                              text: '${Preferences.appString.end}: ',
                                                              style: TextStyle(
                                                                color: ColorResources.textBlackSec,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: DateFormat("dd MMM yyyy").format(DateFormat("dd-MM-yyyy").parse(snapshot.data!.data!.first.registrationEndAt ?? "")),
                                                              style: TextStyle(
                                                                color: ColorResources.textblack,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Divider(),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10),
                                                          color: ColorResources.buttoncolor,
                                                        ),
                                                        child: Text(
                                                          DateFormat("dd-MM-yyyy HH:mm:ss").parse(snapshot.data!.data!.first.startingAt!).difference(DateTime.now()).inSeconds < 0 ? "Attempt Test" : 'Register Now',
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w400,
                                                            height: 0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : AspectRatio(
                                      aspectRatio: 1.6,
                                      child: PageView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        controller: PageController(
                                          viewportFraction: 0.7,
                                        ),
                                        padEnds: false,
                                        // pageSnapping: true,
                                        // allowImplicitScrolling: true,
                                        itemCount: snapshot.data!.data!.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              analytics.logEvent(name: "app_inerest_in_scholar_test", parameters: {
                                                "test_id": snapshot.data?.data?[index].id ?? "",
                                                "title": snapshot.data?.data?[index].title ?? "",
                                              });
                                              Navigator.of(context).push(CupertinoPageRoute(
                                                builder: (context) => ScholarshipTestScreen(
                                                  id: snapshot.data!.data![index].id!,
                                                ),
                                              ));
                                            },
                                            child: Container(
                                              constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.9),
                                              margin: const EdgeInsets.only(left: 10.0),
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: ColorResources.textWhite,
                                                  borderRadius: BorderRadius.circular(
                                                    10,
                                                  ),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Color(0x7FD9D9D9),
                                                      blurRadius: 41,
                                                      offset: Offset(0, 4),
                                                      spreadRadius: 0,
                                                    )
                                                  ]),
                                              child: Column(
                                                spacing: 10,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                    child: Text(
                                                      snapshot.data!.data![index].title!,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        color: ColorResources.textblack,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: CachedNetworkImage(
                                                        placeholder: (context, url) => const Center(
                                                          child: CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                        imageUrl: snapshot.data!.data![index].banner!,
                                                        // fit: BoxFit.cover,
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          const Icon(
                                                            Icons.calendar_month_outlined,
                                                            size: 15,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Expanded(
                                                            child: Text.rich(
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: '${Preferences.appString.startOn}  ',
                                                                    style: TextStyle(
                                                                      color: ColorResources.textBlackSec,
                                                                      fontSize: 10,
                                                                      fontWeight: FontWeight.w400,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: DateFormat("dd MMM yyyy").format(DateFormat("dd-MM-yyyy").parse(snapshot.data!.data![index].startingAt ?? "")),
                                                                    style: TextStyle(
                                                                      color: ColorResources.textblack,
                                                                      fontSize: 10,
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: " | ",
                                                                    style: TextStyle(color: ColorResources.textBlackSec, fontSize: 10, fontWeight: FontWeight.w400),
                                                                  ),
                                                                  TextSpan(
                                                                    text: '${Preferences.appString.end}  ',
                                                                    style: TextStyle(
                                                                      color: ColorResources.textBlackSec,
                                                                      fontSize: 10,
                                                                      fontWeight: FontWeight.w400,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: DateFormat("dd MMM yyyy").format(DateFormat("dd-MM-yyyy").parse(snapshot.data!.data![index].registrationEndAt ?? "")),
                                                                    style: TextStyle(
                                                                      color: ColorResources.textblack,
                                                                      fontSize: 10,
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Divider(),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                color: ColorResources.buttoncolor,
                                                              ),
                                                              child: Text(
                                                                DateFormat("dd-MM-yyyy HH:mm:ss").parse(snapshot.data!.data![index].startingAt!).difference(DateTime.now()).inSeconds < 0 ? "Attempt Test" : 'Register Now',
                                                                textAlign: TextAlign.center,
                                                                style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w400,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                        } else {
                          return Center(
                            child: ErrorWidgetapp(
                              image: SvgImages.error404,
                              text: "Page not found",
                            ),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ],
              const SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 15,
              //     vertical: 10,
              //   ),
              //   child: Container(
              //     padding: const EdgeInsets.all(10),
              //     decoration: BoxDecoration(
              //       color: ColorResources.buttoncolor.withValues(alpha:0.05),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: FutureBuilder<StreamModel>(
              //         initialData: SharedPreferenceHelper.getString(Preferences.getStreamsApi) == 'N/A'
              //             ? StreamModel(status: true, data: [], msg: '')
              //             : StreamModel.fromJson(
              //                 jsonDecode(SharedPreferenceHelper.getString(Preferences.getStreamsApi)!),
              //               ),
              //         future: AuthController().getStream(),
              //         builder: (context, snapshot) {
              //           // if (snapshot.connectionState == ConnectionState.done) {
              //           if (snapshot.hasData) {
              //             return snapshot.data!.data.isEmpty
              //                 ? Center(
              //                     child: EmptyWidget(image: SvgImages.emptycourse, text: 'no Stream'),
              //                   )
              //                 : GridView.builder(
              //                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //                       crossAxisCount: 3,
              //                       crossAxisSpacing: 5,
              //                       mainAxisSpacing: 5,
              //                     ),
              //                     physics: const NeverScrollableScrollPhysics(),
              //                     shrinkWrap: true,
              //                     itemCount: snapshot.data!.data.length,
              //                     itemBuilder: (BuildContext context, int index) {
              //                       return stream(text: snapshot.data!.data[index].title, image: snapshot.data!.data[index].icon, index: index);
              //                     });
              //           } else {
              //             return Center(
              //               child: ErrorWidgetapp(
              //                 image: SvgImages.error404,
              //                 text: "Page not found",
              //               ),
              //             );
              //           }
              //           // } else {
              //           //   return const Center(
              //           //     child: CircularProgressIndicator(),
              //           //   );
              //           // }
              //         }),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: Showcase(
                    titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                    key: homegroupFeature,
                    title: Preferences.apptutor.homegroupFeature?.title,
                    description: Preferences.apptutor.homegroupFeature?.des ?? " Home Screen group feature",
                    tooltipActionConfig: const TooltipActionConfig(
                      alignment: MainAxisAlignment.spaceBetween,
                      actionGap: 16,
                      position: TooltipActionPosition.outside,
                    ),
                    tooltipActions: [
                      tourNext(
                        context: context,
                      ),
                    ],
                    child: GridView.count(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: 3,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: [
                        Showcase(
                          titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                          key: mycourse,
                          title: Preferences.apptutor.mycourse?.title,
                          description: Preferences.apptutor.mycourse?.des ?? "My Course after perchased all course will show here",
                          tooltipActionConfig: const TooltipActionConfig(
                            alignment: MainAxisAlignment.spaceBetween,
                            actionGap: 16,
                            position: TooltipActionPosition.outside,
                          ),
                          tooltipActions: [
                            tourNext(
                              context: context,
                            ),
                          ],
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('mycoursesscreen');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: ColorResources.textWhite,
                                border: Border.all(color: ColorResources.borderColor, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircleAvatar(
                                    radius: 15,
                                    child: Icon(
                                      Icons.auto_stories_outlined,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      Preferences.appString.myCourses ?? "My Course ",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Showcase(
                          titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                          key: myDownloads,
                          tooltipActionConfig: const TooltipActionConfig(
                            alignment: MainAxisAlignment.spaceBetween,
                            actionGap: 16,
                            position: TooltipActionPosition.outside,
                          ),
                          tooltipActions: [
                            tourPrevious(
                              context: context,
                            ),
                            tourNext(
                              context: context,
                            ),
                          ],
                          title: Preferences.apptutor.myDownloads?.title,
                          description: Preferences.apptutor.myDownloads?.des ?? "My downloads will show here",
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('downloadScreen');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: ColorResources.textWhite,
                                border: Border.all(color: ColorResources.borderColor, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircleAvatar(
                                    radius: 15,
                                    child: Icon(
                                      Icons.file_download_outlined,
                                      weight: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      Preferences.appString.myDownloads ?? "My Downloads",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Showcase(
                          titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                          key: myebooks,
                          title: Preferences.apptutor.myebooks?.title,
                          description: Preferences.apptutor.myebooks?.des ?? "My ebooks will show here",
                          tooltipActionConfig: const TooltipActionConfig(
                            alignment: MainAxisAlignment.spaceBetween,
                            actionGap: 16,
                            position: TooltipActionPosition.outside,
                          ),
                          tooltipActions: [
                            tourPrevious(
                              context: context,
                            ),
                            tourNext(
                              context: context,
                            ),
                          ],
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const MyEbookScreen()));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: ColorResources.textWhite,
                                border: Border.all(color: ColorResources.borderColor, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircleAvatar(
                                    radius: 15,
                                    child: Icon(
                                      CupertinoIcons.doc_plaintext,
                                      weight: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      Preferences.appString.myEbooks ?? "My E-books",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Showcase(
                          titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                          key: library,
                          title: Preferences.apptutor.appTourLibrary?.title,
                          description: Preferences.apptutor.appTourLibrary?.des ?? "Library content will here",
                          tooltipActionConfig: const TooltipActionConfig(
                            alignment: MainAxisAlignment.spaceBetween,
                            actionGap: 16,
                            position: TooltipActionPosition.outside,
                          ),
                          tooltipActions: [
                            tourPrevious(
                              context: context,
                            ),
                            tourSkip(
                              context: context,
                            ),
                          ],
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const LibraryHomeScreen()
                                  // const QuizListScreen()
                                  ));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: ColorResources.textWhite,
                                border: Border.all(color: ColorResources.borderColor, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircleAvatar(
                                    radius: 15,
                                    child: Iconify(
                                      Mdi.bookshelf,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Library",
                                      // Preferences.appString.freeQuiz ?? "Free Quiz's",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: remoteDataSourceImpl.getTodayClassRequest(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data?.isEmpty ?? true
                        ? Container()
                        : AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: ColorResources.borderColor,
                              ),
                              color: ColorResources.textWhite,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    Preferences.appString.todayClass ?? 'Today’s Classes',
                                    style: TextStyle(
                                      color: ColorResources.textblack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                const Divider(),
                                SizedBox(
                                  height: 90,
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeBottom: true,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) => Wrap(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              // print(SharedPreferenceHelper.getString(Preferences.name));
                                              // //print(
                                              //     "${lecture.startingDate.toString().split(" ")[0]} ==${DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()}");
                                              //await [Permission.camera, Permission.microphone].request();
                                              if (snapshot.data?[index].lectureType == "YT" && snapshot.data?[index].link != null) {
                                                if (snapshot.data?[index].link?.isNotEmpty ?? false) {
                                                  if (DateFormat("dd-MM-yyyy HH:mm:ss").parse(snapshot.data?[index].startingDate! ?? "").difference(DateTime.now()).inSeconds < 60) {
                                                    analytics.logEvent(name: "app_class_attend", parameters: {
                                                      "lectureTitle": snapshot.data?[index].lectureTitle ?? "",
                                                      "Id": snapshot.data?[index].sId ?? "",
                                                    });
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) => YTClassScreen(
                                                          lecture: snapshot.data?[index] ?? LectureDetails(),
                                                        ),
                                                      ),
                                                    );
                                                    //print("object1");
                                                  } else {
                                                    analytics.logEvent(name: "app_trying_to_attend_class", parameters: {
                                                      "lectureTitle": snapshot.data?[index].lectureTitle ?? "",
                                                      "Id": snapshot.data?[index].sId ?? "",
                                                    });
                                                    flutterToast('Lecture will start at ${DateFormat.jm().format(DateFormat("HH:mm:ss").parse(snapshot.data?[index].startingDate?.split(" ").last ?? ''))}');
                                                  }
                                                } else {
                                                  flutterToast('Lecture link is empty');
                                                }
                                              } else if (snapshot.data?[index].lectureType == "TWOWAY") {
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
                                                    if (DateFormat("dd-MM-yyyy HH:mm:ss").parse(snapshot.data![index].startingDate!).difference(DateTime.now()).inSeconds < 60) {
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (context) => BlocProvider(
                                                                create: (context) => MediasoupCubit(),
                                                                child: LiveClassLecture(
                                                                  lecture: snapshot.data?[index] ?? LectureDetails(),
                                                                  batch: snapshot.data?[index].roomDetails?.batchName ?? "",
                                                                  roomName: snapshot.data?[index].roomDetails?.title ?? "",
                                                                  name: SharedPreferenceHelper.getString(Preferences.name)!,
                                                                  url: snapshot.data?[index].socketUrl ?? "",
                                                                  mentor: snapshot.data?[index].roomDetails?.mentor?.first.mentorName ?? "",
                                                                  token: SharedPreferenceHelper.getString(Preferences.accesstoken) ?? "",
                                                                ),
                                                              )));
                                                    } else {
                                                      flutterToast('Lecture will start at ${DateFormat.jm().format(DateFormat("HH:mm:ss").parse(snapshot.data?[index].startingDate?.split(" ").last ?? ''))}');
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
                                              } else if (snapshot.data?[index].lectureType == "APP") {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) => BlocProvider(
                                                      create: (context) => AppStreamCubit(),
                                                      child: JoinStreamingScreen(lecture: snapshot.data![index]),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                flutterToast('Lecture type not found or not supported');
                                              }
                                              //Navigator.of(context).pushNamed('joinstreaming');
                                            },
                                            child: Container(
                                              width: snapshot.data?.length != 1 ? MediaQuery.of(context).size.width * 0.8 : MediaQuery.of(context).size.width * 0.9,
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
                                                        snapshot.data?[index].lectureTitle ?? '',
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
                                                            "${DateFormat.jm().format(DateFormat("HH:mm:ss").parse(snapshot.data?[index].startingDate?.split(" ").last ?? ''))} to ${DateFormat.jm().format(DateFormat("HH:mm:ss").parse(snapshot.data?[index].endingDate?.split(" ").last ?? ''))}",
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
                                                      //       snapshot.data?[index].startingDate?.split(" ").first ?? '',
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ));
                  } else {
                    return Container();
                    // Center(
                    //   child: CircularProgressIndicator(),
                    // );
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: ColorResources.textWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: ColorResources.borderColor)),
                      child: Column(
                        children: [
                          BlocBuilder<StreamsetectCubit, StreamsetectState>(
                            builder: (context, state) {
                              if (state is StreamsetectInitial) {}
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${Preferences.appString.offeringCoursesForYou} ${context.read<StreamsetectCubit>().selectStreamuser ?? "you"}',
                                    style: GoogleFonts.notoSansDevanagari(
                                      color: ColorResources.textblack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  FutureBuilder<CoursesModel>(
                                    initialData: SharedPreferenceHelper.getString(Preferences.getCourse) == 'N/A' ? CoursesModel(data: [], status: true, msg: '') : CoursesModel.fromJson(jsonDecode(SharedPreferenceHelper.getString(Preferences.getCourse) ?? "")),
                                    future: remoteDataSourceImpl.getpaidCourses(stream: context.read<StreamsetectCubit>().selectStreamuser ?? ""),
                                    builder: (BuildContext context, AsyncSnapshot<CoursesModel> snapshot) {
                                      // if (snapshot.connectionState == ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        return snapshot.data!.data.isEmpty
                                            ? Center(
                                                child: EmptyWidget(image: SvgImages.emptycourse, text: Languages.nocourse),
                                              )
                                            : MediaQuery.removePadding(
                                                context: context,
                                                removeBottom: true,
                                                child: ListView.builder(
                                                  itemCount: snapshot.data!.data.length < 3 ? snapshot.data!.data.length : 3,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return Stack(
                                                      key: Key(snapshot.data?.data[index].id ?? UniqueKey().toString()),
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets.only(top: 10, left: 6, bottom: 5),
                                                          padding: const EdgeInsets.all(8.0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: ColorResources.textWhite,
                                                            border: Border.all(
                                                              color: ColorResources.borderColor,
                                                            ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                snapshot.data!.data[index].batchName,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: GoogleFonts.notoSansDevanagari(
                                                                  color: ColorResources.textblack,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              ClipRRect(
                                                                borderRadius: BorderRadius.circular(10),
                                                                child: CachedNetworkImage(
                                                                  imageUrl: snapshot.data!.data[index].banner[0].fileLoc,
                                                                  width: double.infinity,
                                                                  fit: BoxFit.cover,
                                                                  placeholder: (context, url) => Center(
                                                                    child: ShimmerCustom.rectangular(height: 100),
                                                                  ),
                                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                      flex: 3,
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              const Icon(
                                                                                Icons.track_changes,
                                                                                size: 20,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  '${Preferences.appString.targetedBatchFor} ${snapshot.data!.data[index].subCategory.isEmpty ? snapshot.data!.data[index].stream : snapshot.data!.data[index].subCategory}',
                                                                                  overflow: TextOverflow.clip,
                                                                                  style: GoogleFonts.notoSansDevanagari(
                                                                                    color: ColorResources.textblack,
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          snapshot.data?.data[index].batchFeatureUrl.isEmpty ?? true
                                                                              ? Row(
                                                                                  children: [
                                                                                    const Icon(
                                                                                      Icons.calendar_month_outlined,
                                                                                      size: 20,
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text.rich(
                                                                                        TextSpan(
                                                                                          children: [
                                                                                            TextSpan(
                                                                                              text: 'Start ',
                                                                                              style: GoogleFonts.notoSansDevanagari(
                                                                                                color: ColorResources.textblack,
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w400,
                                                                                              ),
                                                                                            ),
                                                                                            TextSpan(
                                                                                              text: DateFormat("dd MMM yyyy").format(DateFormat("yyy-MM-dd").parse((snapshot.data!.data[index].startingDate.toString().split(' ')[0]))),
                                                                                              style: GoogleFonts.notoSansDevanagari(
                                                                                                color: ColorResources.textblack,
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w500,
                                                                                              ),
                                                                                            ),
                                                                                            TextSpan(
                                                                                              text: ' | End ',
                                                                                              style: GoogleFonts.notoSansDevanagari(
                                                                                                color: ColorResources.textblack,
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w400,
                                                                                              ),
                                                                                            ),
                                                                                            TextSpan(
                                                                                              text: DateFormat("dd MMM yyyy").format(DateFormat("yyyy-MM-dd").parse(snapshot.data!.data[index].endingDate.toString().split(' ')[0])),
                                                                                              style: GoogleFonts.notoSansDevanagari(
                                                                                                color: ColorResources.textblack,
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w500,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              : ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(15),
                                                                                  child: Image.network(
                                                                                    snapshot.data?.data[index].batchFeatureUrl ?? "",
                                                                                    height: 50,
                                                                                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                                                                                  ),
                                                                                ),
                                                                          const Divider(),
                                                                        ],
                                                                      )),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            int.parse(snapshot.data!.data[index].discount) == 0 ? "Free" : '₹${(int.parse(snapshot.data!.data[index].discount))}',
                                                                            style: GoogleFonts.notoSansDevanagari(
                                                                              color: int.parse(snapshot.data!.data[index].discount) == 0 ? Colors.green : ColorResources.buttoncolor,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 10,
                                                                          ),
                                                                          Text(
                                                                            int.parse(snapshot.data!.data[index].discount) < int.parse(snapshot.data!.data[index].charges) ? '₹${snapshot.data!.data[index].charges}  ' : "",
                                                                            style: GoogleFonts.notoSansDevanagari(
                                                                              decoration: TextDecoration.lineThrough,
                                                                              color: ColorResources.gray,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Text(
                                                                        "(For Full Batch)",
                                                                        style: GoogleFonts.notoSansDevanagari(
                                                                          color: ColorResources.textblack,
                                                                          fontSize: 10,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Spacer(
                                                                    flex: 1,
                                                                  ),
                                                                  ClipPath(
                                                                    clipper: LeftArrowClipper(),
                                                                    child: Container(
                                                                      padding: const EdgeInsets.only(left: 15.0, right: 5, bottom: 5, top: 5),
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(100), bottomLeft: Radius.circular(100), topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
                                                                        color: Color(0xFFD5FFD9),
                                                                      ),
                                                                      child: Row(spacing: 5, children: [
                                                                        Transform.flip(
                                                                          flipX: true,
                                                                          child: SvgPicture.string(
                                                                            "<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24'><g fill='none' stroke='currentColor' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' color='currentColor'><path d='M10.996 10h.015M11 16h.015M7 13h8'/><circle cx='1.5' cy='1.5' r='1.5' transform='matrix(1 0 0 -1 16 8)'/><path d='M2.774 11.144c-1.003 1.12-1.024 2.81-.104 4a34 34 0 0 0 6.186 6.186c1.19.92 2.88.899 4-.104a92 92 0 0 0 8.516-8.698a1.95 1.95 0 0 0 .47-1.094c.164-1.796.503-6.97-.902-8.374s-6.578-1.066-8.374-.901a1.95 1.95 0 0 0-1.094.47a92 92 0 0 0-8.698 8.515'/></g></svg>",
                                                                            height: 15,
                                                                            colorFilter: ColorFilter.mode(Color(0xFF1E7026), BlendMode.srcIn),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          int.parse(snapshot.data!.data[index].discount) < int.parse(snapshot.data!.data[index].charges) && int.parse(snapshot.data!.data[index].discount) != 0
                                                                              ? "Discount of ${(((int.parse(snapshot.data!.data[index].charges) - int.parse(snapshot.data!.data[index].discount)) / int.parse(snapshot.data!.data[index].charges)) * 100).toString().split('.').first}% Applied"
                                                                              // : ""
                                                                              : "",
                                                                          style: const TextStyle(
                                                                            color: Color(0xFF1D7025),
                                                                            fontSize: 10,
                                                                            fontWeight: FontWeight.w500,
                                                                            height: 0.9,
                                                                          ),
                                                                        )
                                                                      ]),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: OutlinedButton(
                                                                      onPressed: () {
                                                                        Navigator.push(
                                                                          context,
                                                                          CupertinoPageRoute(
                                                                            builder: (context) => CoursesDetailsScreens(
                                                                              courseId: snapshot.data!.data[index].id,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                                                                        side: BorderSide(width: 1.0, color: ColorResources.buttoncolor),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(10), // <-- Radius
                                                                        ),
                                                                      ),
                                                                      child: Text(
                                                                        Preferences.appString.viewDetails ?? 'View Details',
                                                                        style: GoogleFonts.notoSansDevanagari(
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child: ElevatedButton(
                                                                      onPressed: () {
                                                                        Preferences.onLoading(context);
                                                                        context.read<CoursePlanCubit>().getPlan(id: snapshot.data!.data[index].id).then((_) {
                                                                          Preferences.hideDialog(context);

                                                                          if (context.read<CoursePlanCubit>().plans.length > 1) {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (context) => Dialog.fullscreen(
                                                                                child: CourseValdityScreen(
                                                                                  value: context.read<CoursePlanCubit>().plans,
                                                                                  batchName: snapshot.data!.data[index].batchName,
                                                                                  data: coursedetailsmodel.BatchDetails.fromJson(snapshot.data!.data[index].toJson()),
                                                                                  isCheckOut: false,
                                                                                  isEnroll: false,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          } else if (context.read<CoursePlanCubit>().plans.length == 1) {
                                                                            CoursesDataModel data = snapshot.data!.data[index];
                                                                            data.discount = (context.read<CoursePlanCubit>().plans.first.salePrice ?? 0).toString();
                                                                            data.charges = (context.read<CoursePlanCubit>().plans.first.regularPrice ?? 0).toString();
                                                                            Navigator.push(
                                                                              context,
                                                                              CupertinoPageRoute(
                                                                                builder: (context) => CoursePaymentScreen(
                                                                                  course: snapshot.data!.data[index],
                                                                                  isEnroll: false,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          } else {
                                                                            Navigator.push(
                                                                              context,
                                                                              CupertinoPageRoute(
                                                                                builder: (context) => CoursePaymentScreen(
                                                                                  course: snapshot.data!.data[index],
                                                                                  isEnroll: false,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                        }).onError((error, stackTrace) {
                                                                          Preferences.hideDialog(context);
                                                                        });
                                                                        // callApiaddtocart(snapshot.data!.data[index].id);
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                                                                        backgroundColor: ColorResources.buttoncolor,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(10), // <-- Radius
                                                                        ),
                                                                      ),
                                                                      child: Text(
                                                                        Preferences.appString.buyNow ?? 'Buy Now',
                                                                        style: GoogleFonts.notoSansDevanagari(
                                                                          fontSize: 12,
                                                                          color: ColorResources.textWhite,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  // const Spacer(),
                                                                  // CircleAvatar(
                                                                  //   backgroundColor: ColorResources.buttoncolor.withValues(alpha:0.05),
                                                                  //   radius: 15,
                                                                  //   child: Icon(
                                                                  //     Icons.share,
                                                                  //     color: ColorResources.textblack,
                                                                  //     size: 20,
                                                                  //   ),
                                                                  // )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          left: 0,
                                                          child: SvgPicture.string(
                                                            BannerLangSvg().getBannerSvg(type: BannerLangSvg().gettype(lang: snapshot.data?.data[index].language ?? "en")),
                                                            height: 20,
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                ),
                                              );
                                      } else {
                                        return ErrorWidgetapp(image: SvgImages.error404, text: 'internal serror error');
                                      }
                                      // } else {
                                      //   return const Center(
                                      //     child: CircularProgressIndicator(),
                                      //   );
                                      // }
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    // SharedPreferenceHelper.setInt(Preferences.selectedStream, 0);
                                    Navigator.of(context).popUntil((route) => false);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const HomeScreen(
                                          index: 1,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                                    side: BorderSide(width: 1.0, color: ColorResources.buttoncolor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10), // <-- Radius
                                    ),
                                  ),
                                  child: Text(
                                    Preferences.appString.viewMore ?? 'VIEW MORE',
                                    style: GoogleFonts.notoSansDevanagari(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: ColorResources.buttoncolor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              !Preferences.remoteReferAndEarn["home_screen"]["card"]["isActive"]
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: ColorResources.gray.withValues(alpha: 0.2),
                            spreadRadius: 0,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              color: ColorResources.textWhite,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints: const BoxConstraints(maxWidth: 180),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorResources.buttoncolor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.redeem_outlined,
                                            color: Colors.white,
                                            weight: 1,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            Preferences.remoteReferAndEarn["home_screen"]["card"]["title"] ?? "", //'REFER AND EARN',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      Preferences.remoteReferAndEarn["home_screen"]["card"]["subTitle"], // 'Learn Together. Earn Together',
                                      style: TextStyle(
                                        color: ColorResources.textblack,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      (Preferences.remoteReferAndEarn["home_screen"]["card"]["body"] as String).contains("{myReferralCode}") ? (Preferences.remoteReferAndEarn["home_screen"]["card"]["body"] as String).replaceAll("{myReferralCode}", SharedPreferenceHelper.getString(Preferences.myReferralCode)!) : (Preferences.remoteReferAndEarn["home_screen"]["card"]["body"] as String), //'Invite your Friends to join Sd Campus. You get upto 20% of the purchase amount as Paytm cashback on your friend’s purchase. Your friends get upto 10% discount on their purchase with your code',
                                      style: TextStyle(
                                        color: ColorResources.textblack,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 10,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    imageUrl: SvgImages.coin,
                                    height: 60,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            decoration: BoxDecoration(
                              color: ColorResources.buttoncolor,
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: ColorResources.textWhite,
                                      // border: RDottedLineBorder.all(color: ColorResources.buttoncolor),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(text: SharedPreferenceHelper.getString(Preferences.myReferralCode)!));
                                        flutterToast('copy to clipboard successfully');
                                        analytics.logEvent(name: "app_refer_code_copy");
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            SharedPreferenceHelper.getString(Preferences.myReferralCode)!,
                                            style: const TextStyle(
                                              // color: ColorResources.buttoncolor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.copy,
                                            // color: ColorResources.buttoncolor,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      analytics.logEvent(name: "app_share_referal");
                                      try {
                                        Share.share(
                                          (Preferences.remoteReferAndEarn["home_screen"]["card"]["sharedataButton"] as String).contains("{myReferralCode}") ? (Preferences.remoteReferAndEarn["home_screen"]["card"]["sharedataButton"] as String).replaceAll("{myReferralCode}", SharedPreferenceHelper.getString(Preferences.myReferralCode)!) : (Preferences.remoteReferAndEarn["home_screen"]["card"]["sharedataButton"] as String),
                                          // "🌟 Exciting news! Discovered SD Campus App - top-notch courses & online bookstore. 📚 Join using my code ${SharedPreferenceHelper.getString(Preferences.myReferralCode)}  for exclusive benefits! Let's boost our learning journey together! 🚀 \n\n Download Now : https://sdcampus.onelink.me/rnhk/SDCampusApp", //{myReferralCode}
                                        );
                                      } catch (e) {
                                        // print(e);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorResources.textWhite,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        Preferences.appString.inviteyourfriends ?? 'Invite Your Friends',
                                        style: const TextStyle(
                                          // color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: ColorResources.textWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        Preferences.appString.sdCampusYouTubeChannel ?? 'SD Campus YouTube Channels',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorResources.textblack,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    const Divider(),
                    (Preferences.remoteSocial["youtube"] as List).isEmpty
                        ? Container()
                        : SizedBox(
                            height: 100,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => GestureDetector(
                                      onTap: () {
                                        analytics.logEvent(name: "youtube_channel_click");
                                        launchUrl(
                                          Uri.parse(Preferences.remoteSocial["youtube"][index]["youTubeUrl"]),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: ColorResources.borderColor),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              radius: 35,
                                              foregroundImage: CachedNetworkImageProvider(Preferences.remoteSocial["youtube"][index]["dpImageUrl"]),
                                              backgroundColor: ColorResources.buttoncolor,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              Preferences.remoteSocial["youtube"][index]["channelName"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: ColorResources.textblack,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                separatorBuilder: (context, index) => const SizedBox(
                                      width: 10,
                                    ),
                                itemCount: Preferences.remoteSocial["youtube"].length),
                          )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: ColorResources.textWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Preferences.appString.needOurHelp ?? 'Need Our Help?',
                      style: TextStyle(
                        color: ColorResources.textblack,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    Divider(),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            OutlinedButton(
                              onPressed: () {
                                launchUrl(Uri.parse("tel:${Preferences.remoteSocial["number"]}"));
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                  color: ColorResources.buttoncolor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.ring_volume_outlined,
                                    color: ColorResources.buttoncolor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${Preferences.appString.call} ${Preferences.remoteSocial["number"]}',
                                    style: TextStyle(
                                      color: ColorResources.buttoncolor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorResources.buttoncolor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                launchUrl(
                                  Uri.parse("https://wa.me/${Preferences.remoteSocial["whatsAppNumber"]}"),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    imageUrl: SvgImages.whatsapp,
                                    height: 25,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    Preferences.appString.chatOnWhatsApp ?? 'Chat on WhatsApp',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: CachedNetworkImage(
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          imageUrl: SvgImages.helpandsupport,
                          fit: BoxFit.fitWidth,
                          height: 120,
                        ))
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  'Affordable Education For \nEvery Student',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            analytics.logEvent(
                              name: "app_join_facebook",
                              parameters: {
                                "data": DateTime.now().toString(),
                              },
                            );
                            launchUrl(
                              Uri.parse(Preferences.remoteSocial["facebook"]),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: CachedNetworkImage(
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            imageUrl: SvgImages.facebook,
                            height: 40,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      // Expanded(
                      //     child: GestureDetector(
                      //         onTap: () {
                      //           analytics.logEvent(
                      //             name: "app_join_youtube",
                      //             parameters: {
                      //               "data": DateTime.now().toString(),
                      //             },
                      //           );
                      //           launchUrl(
                      //             Uri.parse(Preferences.remoteSocial["youtube"]),
                      //             mode: LaunchMode.externalApplication,
                      //           );
                      //         },
                      //         child: Image.network(
                      //           SvgImages.youtube,
                      //           height: 40,
                      //         ))),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          analytics.logEvent(
                            name: "app_join_instagram",
                            parameters: {
                              "data": DateTime.now().toString(),
                            },
                          );
                          launchUrl(
                            Uri.parse(Preferences.remoteSocial["instagram"]),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: CachedNetworkImage(
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          imageUrl: SvgImages.instagram,
                          height: 40,
                        ),
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          analytics.logEvent(
                            name: "app_join_twitter",
                            parameters: {
                              "data": DateTime.now().toString(),
                            },
                          );
                          launchUrl(
                            Uri.parse(Preferences.remoteSocial["twitter"]),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: CachedNetworkImage(
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          imageUrl: SvgImages.twitterbackground,
                          height: 40,
                        ),
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          analytics.logEvent(
                            name: "app_join_telegram",
                            parameters: {
                              "data": DateTime.now().toString(),
                            },
                          );
                          launchUrl(
                            Uri.parse(Preferences.remoteSocial["telegram"]),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: CachedNetworkImage(
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          imageUrl: SvgImages.telegram,
                          height: 40,
                        ),
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          analytics.logEvent(
                            name: "app_join_linkedin",
                            parameters: {
                              "data": DateTime.now().toString(),
                            },
                          );
                          launchUrl(
                            Uri.parse(Preferences.remoteSocial["linkedin"]),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: CachedNetworkImage(
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          imageUrl: SvgImages.linkdin,
                          height: 40,
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.all(5.0),
              //   margin: const EdgeInsets.symmetric(horizontal: 15),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //     boxShadow: [
              //       BoxShadow(
              //         color: ColorResources.gray.withValues(alpha:0.2),
              //         spreadRadius: 0,
              //         blurRadius: 2,
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.only(left: 20, top: 15),
              //         child: Text(
              //           Preferences.appString.joinUsOn ?? Languages.ncertBatches,
              //           style: GoogleFonts.notoSansDevanagari(
              //             color: ColorResources.textblack,
              //             fontSize: 16,
              //             fontWeight: FontWeight.w600,
              //             height: 0,
              //           ),
              //         ),
              //       ),
              //       const Divider(),
              //     ],
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       GestureDetector(
              //         onTap: () {
              //           launchUrl(Uri.parse("https://www.youtube.com/@teachingexamssdcampus"), mode: LaunchMode.externalApplication);
              //         },
              //         child: Container(
              //             height: 100,
              //             width: MediaQuery.of(context).size.width * 0.45,
              //             decoration: BoxDecoration(color: ColorResources.youtube, borderRadius: BorderRadius.circular(20)),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.spaceAround,
              //               children: [
              //                 CachedNetworkImage(
              //                   height: 60,
              //                   imageUrl: SvgImages.youtube,
              //                   placeholder: (context, url) => const Center(
              //                     child: CircularProgressIndicator(),
              //                   ),
              //                   errorWidget: (context, url, error) => const Icon(Icons.error),
              //                 ),
              //               ],
              //             )),
              //       ),
              //       GestureDetector(
              //         onTap: () {
              //           launchUrl(Uri.parse("https://t.me/sd_campus"), mode: LaunchMode.externalApplication);
              //         },
              //         child: Container(
              //           height: 100,
              //           width: MediaQuery.of(context).size.width * 0.45,
              //           decoration: BoxDecoration(color: ColorResources.telegarm, borderRadius: BorderRadius.circular(20)),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.spaceAround,
              //             children: [
              //               CachedNetworkImage(
              //                 height: 60,
              //                 imageUrl: SvgImages.telegram,
              //                 placeholder: (context, url) => const Center(
              //                   child: CircularProgressIndicator(),
              //                 ),
              //                 errorWidget: (context, url, error) => const Icon(Icons.error),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: (Preferences.tutorVideo.isEnabled ?? false) && showDemo
          ? Stack(
              children: [
                Builder(builder: (context) {
                  return DraggableWidget(
                    verticalSpace: 20,
                    horizontalSpace: 10,
                    bottomMargin: kBottomNavigationBarHeight + 140,
                    dragController: draggableController,
                    child:
                        // Container(
                        //   height: 100,
                        //   width: 100,
                        //   color: Colors.black,
                        // ),
                        DemoPlayerWidget(
                      videoUrl: Preferences.tutorVideo.url ?? "",
                      autoplay: Preferences.tutorVideo.autoplay ?? false,
                      isLoop: Preferences.tutorVideo.isLoop ?? false,
                      url: Preferences.tutorVideo.link ?? "",
                      close: (isFullScreen) {
                        safeSetState(() {
                          Preferences.tutorVideo.isEnabled = false;
                          SharedPreferenceHelper.setInt(Preferences.demoClosed, SharedPreferenceHelper.getInt(Preferences.demoClosed) + 1);
                          if (isFullScreen) {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                    ),
                  );
                })
              ],
            )
          : null,
    );
  }

  // Container myCoursesCardWidget(MyCoursesDataModel data) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
  //     width: MediaQuery.of(context).size.width * 0.6,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20),
  //       color: ColorResources.textWhite,
  //       boxShadow: [
  //         BoxShadow(
  //           color: ColorResources.gray.withValues(alpha:0.5),
  //           blurRadius: 5.0,
  //         ),
  //       ],
  //     ),
  //     padding: const EdgeInsets.all(8),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(left: 8.0),
  //           child: Text(
  //             data.batchDetails!.batchName!,
  //             overflow: TextOverflow.ellipsis,
  //             maxLines: 1,
  //             style: GoogleFonts.notoSansDevanagari(
  //               fontSize: Fontsize().h3,
  //               fontWeight: FontWeight.bold,
  //               color: ColorResources.textblack,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 2,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             Column(
  //               children: [
  //                 const Icon(
  //                   Icons.sensors_outlined,
  //                 ),
  //                 Text(
  //                   'Live lectures',
  //                   style: GoogleFonts.notoSansDevanagari(fontSize: 8),
  //                 )
  //               ],
  //             ),
  //             Column(
  //               children: [
  //                 const Icon(Icons.signal_cellular_alt),
  //                 Text(
  //                   '100% Online',
  //                   style: GoogleFonts.notoSansDevanagari(fontSize: 8),
  //                 )
  //               ],
  //             ),
  //             Column(
  //               children: [
  //                 const Icon(Icons.download),
  //                 Text(
  //                   'Downloadable',
  //                   style: GoogleFonts.notoSansDevanagari(fontSize: 8),
  //                 )
  //               ],
  //             )
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 8,
  //         ),
  //         Align(
  //           alignment: Alignment.centerRight,
  //           child: Container(
  //             width: MediaQuery.of(context).size.width * 0.22,
  //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //             decoration: BoxDecoration(
  //               color: ColorResources.buttoncolor,
  //               borderRadius: BorderRadius.circular(15),
  //             ),
  //             child: InkWell(
  //               onTap: () {
  //                 Navigator.of(context).push(MaterialPageRoute(
  //                   builder: (context) => CourseViewScreen(
  //                     lecture: data.lectureDetails!,
  //                     batch: data.batchDetails!,
  //                     index: 0,
  //                   ),
  //                 ));
  //                 //Navigator.pushNamed(context, 'mycoursesscreen');
  //               },
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     Languages.continueText,
  //                     style: GoogleFonts.notoSansDevanagari(
  //                       fontSize: 10,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                     ),
  //                   ), // <-- Text
  //                   Container(
  //                     padding: const EdgeInsets.all(4),
  //                     decoration: BoxDecoration(
  //                       color: ColorResources.textWhite.withValues(alpha:0.3),
  //                       shape: BoxShape.circle,
  //                     ),
  //                     child: const Icon(
  //                       Icons.arrow_forward_ios,
  //                       size: 10,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         // GestureDetector(
  //         //   onTap: () {
  //         //     Navigator.pushNamed(context, 'mycoursesscreen');
  //         //   },
  //         //   child: Align(
  //         //     alignment: Alignment.centerRight,
  //         //     child: Container(
  //         //       width: MediaQuery.of(context).size.width * 0.28,
  //         //       padding:
  //         //             EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //         //       decoration: BoxDecoration(
  //         //         color: ColorResources.buttoncolor,
  //         //         borderRadius: BorderRadius.circular(15),
  //         //       ),
  //         //       child: Row(
  //         //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //         children: [
  //         //           Text(
  //         //             'Continue',
  //         //             style: GoogleFonts.notoSansDevanagari(
  //         //               fontSize: 12,
  //         //               color: Colors.white,
  //         //             ),
  //         //           ), // <-- Text
  //         //             SizedBox(
  //         //             width: 2,
  //         //           ),
  //         //           Container(
  //         //             padding:   EdgeInsets.all(5),
  //         //             decoration: BoxDecoration(
  //         //               color: ColorResources.gray.withValues(alpha:0.3),
  //         //               shape: BoxShape.circle,
  //         //             ),
  //         //             child:   Icon(
  //         //               Icons.arrow_forward_ios,
  //         //               size: 10,
  //         //               color: Colors.white,
  //         //             ),
  //         //           ),
  //         //         ],
  //         //       ),
  //         //     ),
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  Widget quickaccess({
    required String image,
    required String name,
    required void Function()? ontap,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            Image.asset(
              image,
              height: 50,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSansDevanagari(
                fontWeight: FontWeight.w600,
                fontSize: 10,
                color: ColorResources.textblack,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Future<void> callApiaddtocart(String courseId) async {
  //   // AddToCart response;
  //   Map<String, dynamic> body = {
  //     "batch_id": courseId,
  //   };
  //   try {
  //     safeSetState(() {
  //       Preferences.onLoading(context);
  //     });
  //     // var token =
  //     // SharedPreferenceHelper.getString(Preferences.access_token).toString();
  //     Response response = await dioAuthorizationData().post(
  //       '${Apis.baseUrl}${Apis.addtocart}',
  //       data: body,
  //     );
  //     if (response.data['status']) {
  //       safeSetState(() {
  //         Preferences.hideDialog(context);
  //       });
  //       Navigator.of(context).pushNamed('cartscreen');
  //       Fluttertoast.showToast(
  //         msg: '${response.data['msg']}',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: ColorResources.gray,
  //         textColor: ColorResources.textWhite,
  //       );
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: '${response.data['msg']}',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: ColorResources.gray,
  //         textColor: ColorResources.textWhite,
  //       );
  //     }
  //   } catch (error) {
  //     safeSetState(() {
  //       Preferences.hideDialog(context);
  //     });
  //   }
  // }

  // Widget stream({required String text, required int index, required String image}) {
  //   return GestureDetector(
  //       onTap: () async {
  //         analytics.logEvent(name: "app_select_stream", parameters: {
  //           "namestream": text,
  //         });
  //         SharedPreferenceHelper.setInt(Preferences.selectedStream, 1);
  //         Navigator.of(context).popUntil((route) => false);
  //         Navigator.of(context).push(MaterialPageRoute(
  //           builder: (context) => const HomeScreen(index: 1),
  //         ));
  //         context.read<StreamsetectCubit>().courseStreamSelected(selected: text);
  //         // selectedStream.contains(text) ? selectedStream.remove(text) : selectedStream.add(text);
  //         // context.read<StreamsetectCubit>().selectStream(stream: selectedStream).then((value) => selectedStream = SharedPreferenceHelper.getStringList(Preferences.course));
  //       },
  //       child: Container(
  //         padding: const EdgeInsets.all(8.0),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           color: ColorResources.textWhite,
  //           border: Border.all(
  //             color: ColorResources.borderColor,
  //           ),
  //         ),
  //         alignment: Alignment.center,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Expanded(
  //               flex: 9,
  //               child: CircleAvatar(
  //                 radius: 40,
  //                 backgroundColor: Colors.transparent,
  //                 child: CachedNetworkImage(
  //                   imageUrl: image,
  //                   fit: BoxFit.cover,
  //                   placeholder: (context, url) => Center(
  //                     child: ShimmerCustom.rectangular(height: 10),
  //                   ),
  //                   errorWidget: (context, url, error) => const Icon(Icons.error),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             Expanded(
  //               flex: 5,
  //               child: Center(
  //                 child: Text(
  //                   text,
  //                   textAlign: TextAlign.center,
  //                   style: GoogleFonts.notoSansDevanagari(
  //                     color: ColorResources.textblack,
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       ));
  // }
}

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  List<Widget> images = [];
  final carousel_slider.CarouselSliderController _CarouselController = carousel_slider.CarouselSliderController();

  int sliderindex = 0;

  bool loading = true;
  Future<BaseModel<Getbannerdetails>> callApigetbanner({String? categoryName}) async {
    Getbannerdetails response;
    try {
      response = await RestClient(RetroApi2().dioData2()).bannerimagesRequest(categoryName: categoryName);
      // print(response.msg);
      for (var entry in response.data ?? []) {
        images.add(
          GestureDetector(
            onTap: () {
              if (response.data![response.data!.indexOf(entry)].link == 'batch') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CoursesDetailsScreens(
                    courseId: response.data![response.data!.indexOf(entry)].linkWith!.id!,
                  ),
                ));
              } else if (response.data![response.data!.indexOf(entry)].link == 'testSeries') {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => TestSeriesDetailScreen(
                //     testseriesId: response.data![response.data!.indexOf(entry)].linkWith!.id!,
                //   ),
                // ));
              } else if (response.data![response.data!.indexOf(entry)].link == 'link') {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => TestSeriesDetailScreen(
                //     testseriesId: response.data![response.data!.indexOf(entry)].linkWith!.id!,
                //   ),
                // ));
                launchUrl(Uri.parse(response.data![response.data!.indexOf(entry)].linkWith!.id!.toString()), mode: LaunchMode.externalApplication);
              } else if (response.data![response.data!.indexOf(entry)].link == "scholarship") {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ScholarshipTestScreen(
                    id: response.data![response.data!.indexOf(entry)].linkWith!.id!.toString(),
                  ),
                ));
              }
            },
            child: CachedNetworkImage(
              imageUrl: entry.bannerUrl ?? "",
              placeholder: (context, url) => Center(
                child: ShimmerCustom.rectangular(
                  height: 100,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        );
      }
      safeSetState(() {
        loading = false;
      });
    } catch (error) {
      // print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Preferences.awareApp["inAppReview"]) {
        try {
          if (await Preferences.inAppReview.isAvailable()) {
            Preferences.inAppReview.requestReview();
          }
        } catch (e) {
          // print(e);
        }
      }
    });
    try {
      callApigetbanner(categoryName: context.read<StreamsetectCubit>().selectStreamuser);
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? ShimmerCustom.rectangular(height: 140)
        : BlocConsumer<StreamsetectCubit, StreamsetectState>(
            listener: (context, state) {
              if (state is TopCourseStreamSelected) {
                images.clear();
                try {
                  callApigetbanner(categoryName: context.read<StreamsetectCubit>().selectStreamuser);
                } catch (e) {
                  // print(e);
                }
              }
            },
            builder: (context, state) {
              // print(state);
              return Stack(
                children: [
                  carousel_slider.CarouselSlider(
                    items: images,
                    carouselController: _CarouselController,
                    options: carousel_slider.CarouselOptions(
                      height: 140,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      onPageChanged: (index, reason) {
                        // print(index);
                        // context.read<StreamsetectCubit>(). .emit(StreamsetectInitial());
                        safeSetState(() {
                          sliderindex = index;
                        });
                      },
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: SizedBox(
                          height: 15,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (context, index) => Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: sliderindex == index ? ColorResources.buttoncolor : Colors.grey,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              );
            },
          );
  }
}
