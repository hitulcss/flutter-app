
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sd_campus_app/features/cubit/course_plan/plan_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';
import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';
import 'package:sd_campus_app/features/presentation/bloc/api_bloc/api_bloc.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/shimmer_custom.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/bottomnav/course_valdity.dart';
import 'package:sd_campus_app/view/screens/course/courseview.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ApiBloc>().add(GetMyCourses());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          //'My Courses'
          Languages.myCourses,
          style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
        ),
      ),
      body: BlocBuilder<ApiBloc, ApiState>(
        builder: (context, state) {
          if (state is ApiError) {
            return Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.6, width: MediaQuery.of(context).size.width * 0.8, child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"))
                //Text('Pls Refresh (or) Reopen App'),
                );
          }
          if (state is ApiMyCoursesSuccess) {
            if (state.myCourses.isEmpty) {
              return EmptyWidget(
                text: Languages.nocourse,
                image: SvgImages.emptycourse,
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.myCourses.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _myCoursesCardWidget(
                    context,
                    state.myCourses[index],
                  ),
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Center _myCoursesCardWidget(BuildContext context, MyCoursesDataModel courseData) {
    // print("courses status");
    // print(courseData.batchDetails!.isActive);
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
          color: Colors.white,
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.grey,
          //     blurRadius: 5.0,
          //   ),
          // ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseData.batchName ?? "",
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textblack,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  (courseData.banner?.isEmpty ?? true)
                      ? Container()
                      : Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: courseData.banner?.first.fileLoc ?? "",
                              placeholder: (context, url) => Center(
                                child: ShimmerCustom.rectangular(height: 100),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.track_changes_outlined, size: 25),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          '${Preferences.appString.targetedBatchFor ?? "Targeted Batch for"} ${courseData.stream ?? " "}',
                          style: TextStyle(
                            color: ColorResources.textblack,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: const TextStyle(overflow: TextOverflow.clip),
                            children: [
                              TextSpan(
                                text: "${Preferences.appString.startOn ?? 'Starts on '} ",
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textBlackSec,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: DateFormat("dd MMM yyyy").format(DateFormat("yyyy-MM-dd").parse(courseData.startingDate ?? "")),
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: ' | ',
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textBlackSec,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '${Preferences.appString.end ?? "End's on"} ',
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textBlackSec,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: DateFormat("dd MMM yyyy").format(DateFormat("yyyy-MM-dd").parse(courseData.endingdate ?? "")),
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if ((courseData.isPaid ?? true) && courseData.daysLeft != null && (courseData.daysLeft ?? 0) < 30) ...[
                    SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Icon(
                        Icons.lock_clock_outlined,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        ((courseData.daysLeft ?? 0) <= 0) ? "Batch Expired" : "Batch Expiring  In ${(courseData.daysLeft ?? 1)} Days",
                        style: GoogleFonts.notoSansDevanagari(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ])
                  ],
                  // Text(
                  //   courseData.batchDetails!.batchName!,
                  //   style: GoogleFonts.notoSansDevanagari(fontSize: 24),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       '${DateFormat('yyyy-MM-dd').parse(courseData.batchDetails!.endingDate!).difference(DateTime.now()).inDays} ${Languages.daysRemaining}',
                  //       style: GoogleFonts.notoSansDevanagari(color: ColorResources.gray),
                  //     ),
                  //     ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: ColorResources.buttoncolor,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(20),
                  //         ),
                  //       ),
                  //       onPressed: () {
                  //         if (courseData.isActive!) {
                  //           Navigator.of(context).push(
                  //             MaterialPageRoute(
                  //               builder: (context) => CourseViewScreen(
                  //                 lecture: courseData.lectureDetails!,
                  //                 batch: courseData.batchDetails!,
                  //                 index: 0,
                  //               ),
                  //             ),
                  //           );
                  //         }
                  //       },
                  //       child: Row(
                  //         mainAxisSize: MainAxisSize.min,
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text(
                  //             courseData.isActive! ? Languages.continueText : 'Expired',
                  //             style: TextStyle(
                  //               color: ColorResources.textWhite,
                  //             ),
                  //           ), // <-- Text
                  //           const SizedBox(
                  //             width: 5,
                  //           ),
                  //           Container(
                  //             padding: const EdgeInsets.all(4),
                  //             decoration: BoxDecoration(
                  //               color: ColorResources.textWhite.withValues(alpha:0.3),
                  //               shape: BoxShape.circle,
                  //             ),
                  //             child: const Icon(
                  //               Icons.arrow_forward_ios,
                  //               color: Colors.white,
                  //               size: 15,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: ColorResources.buttoncolor,
                      ),
                      onPressed: () async {
                        if (courseData.isPaid ?? true) {
                          if (courseData.daysLeft != null && (courseData.daysLeft ?? 0) < 7 && (courseData.daysLeft ?? 0) > 0) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 10),
                                      CircleAvatar(
                                        radius: 30,
                                        child: Icon(
                                          Icons.notifications_none_sharp,
                                          size: 30,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text("Batch Expiring in ${(courseData.daysLeft ?? 1)} Days"),
                                      Divider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    side: BorderSide(
                                                      width: 2,
                                                      style: BorderStyle.solid,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(color: Colors.red),
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                        CupertinoPageRoute(
                                                          builder: (context) => CourseViewScreen(
                                                            batchId: courseData.batchId ?? "",
                                                            courseName: courseData.batchName ?? "",
                                                            // index: ,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      "Continue",
                                                      style: TextStyle(
                                                        color: ColorResources.textWhite,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    )))
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else if (courseData.daysLeft != null && (courseData.daysLeft ?? 0) <= 0) {
                            // Renewal BATCH
                            try {
                              Preferences.onLoading(context);
                              CoursesDetailsModel coursesDetailsModel;
                              coursesDetailsModel = await Future(() async {
                                await context.read<CoursePlanCubit>().getPlan(id: courseData.batchId ?? "");
                                return await RemoteDataSourceImpl().getCoursesDetails(courseData.batchId ?? "");
                              });
                              Preferences.hideDialog(context);
                              if (coursesDetailsModel.status ?? false) {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog.fullscreen(
                                    child: CourseValdityScreen(
                                      value: context.read<CoursePlanCubit>().plans,
                                      batchName: courseData.batchName ?? "",
                                      data: coursesDetailsModel.data!.batchDetails!,
                                      isCheckOut: false,
                                      isEnroll: true,
                                    ),
                                  ),
                                );
                              } else {
                                Preferences.hideDialog(context);
                              }
                            } catch (e) {
                              Preferences.hideDialog(context);
                            }
                          } else {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => CourseViewScreen(
                                  batchId: courseData.batchId ?? "",
                                  courseName: courseData.batchName ?? "",
                                  // index: ,
                                ),
                              ),
                            );
                          }
                        } else {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => CourseViewScreen(
                                batchId: courseData.batchId ?? "",
                                courseName: courseData.batchName ?? "",
                                // index: ,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        (courseData.isPaid ?? true) && courseData.daysLeft != null && (courseData.daysLeft ?? 0) <= 0 ? 'Renewal Batch' : Preferences.appString.letsStudy ?? 'Let’s Study',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
    );
  }
}
