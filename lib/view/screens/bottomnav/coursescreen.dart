import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/cubit/course_filter/coursefilter_cubit.dart';
import 'package:sd_campus_app/features/cubit/streamselect/streamsetect_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/coursesmodel.dart';
import 'package:sd_campus_app/features/data/remote/models/stream_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/course_body_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/shimmer_custom.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/bottomnav/homescreen.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<SubCategories> subject = [];
  SubCategories selectedSubject = SubCategories(id: null, title: 'ALL');
  SubCategories fselectedSubject = SubCategories(id: null, title: 'ALL');

  ScrollController scrollController = ScrollController();
  ScrollController fscrollController = ScrollController();
  bool isVisable = true;
  bool isFvisable = true;
  StreamModel getStreamsApi = StreamModel.fromJson(json.decode(SharedPreferenceHelper.getString(Preferences.getStreamsApi) == "N/A" ? '{}' : SharedPreferenceHelper.getString(Preferences.getStreamsApi) ?? "{}"));
  @override
  void initState() {
    super.initState();
    scrollController.addListener(hidebanner);
    fscrollController.addListener(fhidebanner);
    analytics.logEvent(name: "app_course_view");
    _tabController = TabController(length: 2, vsync: this);
    // _tabController!.animateTo(SharedPreferenceHelper.getInt(Preferences.selectedStream));
    // SharedPreferenceHelper.setInt(Preferences.selectedStream, 0);
    // subject.addAll(SharedPreferenceHelper.getStringList(Preferences.getStreams));
    getstream();
  }

  void hidebanner() {
    ScrollDirection scrollDirection = scrollController.position.userScrollDirection;
    if (scrollController.offset == scrollController.position.minScrollExtent && scrollDirection == ScrollDirection.forward) {
      log("scroll");
      isVisable = true;
      context.read<StreamsetectCubit>().stateupdate();
    } else if (scrollDirection == ScrollDirection.reverse) {
      log("scroll");
      isVisable = false;
      context.read<StreamsetectCubit>().stateupdate();
    }
  }

  void fhidebanner() {
    ScrollDirection scrollDirection = fscrollController.position.userScrollDirection;
    if (fscrollController.offset == fscrollController.position.minScrollExtent && scrollDirection == ScrollDirection.forward) {
      isFvisable = true;
      context.read<StreamsetectCubit>().stateupdate();
    } else if (scrollDirection == ScrollDirection.reverse) {
      context.read<StreamsetectCubit>().stateupdate();
      isFvisable = false;
    }
  }

  getstream() {
    StreamDataModel seleted = getStreamsApi.data!.firstWhere((element) => element.title == context.read<StreamsetectCubit>().selectStreamuser, orElse: () => getStreamsApi.data!.first);
    subject.clear();
    seleted.subCategories?.forEach((element) {
      subject.add(element);
    });
    if (subject.isNotEmpty) {
      subject.insert(0, SubCategories(id: null, title: "ALL"));
    }
  }

  @override
  void dispose() {
    _tabController?.dispose(); // Dispose of the tab controller
    scrollController.removeListener(hidebanner);
    scrollController.dispose(); // Dispose
    fscrollController.removeListener(fhidebanner);
    fscrollController.dispose(); // Dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("build");
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              constraints: const BoxConstraints.expand(height: 50),
              color: Colors.white,
              child: TabBar(
                // tabAlignment: TabAlignment.start,
                controller: _tabController,
                indicatorColor: ColorResources.buttoncolor,
                // isScrollable: true,
                labelColor: ColorResources.buttoncolor,
                unselectedLabelColor: ColorResources.textblack.withValues(alpha: 0.6),
                labelStyle: GoogleFonts.notoSansDevanagari(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                onTap: (value) {
                  isVisable = true;
                  isFvisable = true;
                  if (value == 0) {
                    analytics.logEvent(name: "app_paidcourse");
                  } else if (value == 1) {
                    analytics.logEvent(name: "app_freecourse");
                  }
                },
                tabs: [
                  // Tab(
                  //   text: 'My Course',
                  // ),
                  Tab(
                    text: Preferences.appString.paidCourse ?? 'Paid Courses',
                  ),
                  Tab(
                    text: Preferences.appString.freeCourse ?? 'Free Courses',
                  ),
                ],
              ),
            ),
            Expanded(
                child: TabBarView(controller: _tabController, physics: const NeverScrollableScrollPhysics(), children: [
              // FutureBuilder<MyCoursesModel>(
              //   initialData: SharedPreferenceHelper.getString(Preferences.getMyCourse) != 'N/A' ? MyCoursesModel.fromJson(jsonDecode(SharedPreferenceHelper.getString(Preferences.getMyCourse)!)) : MyCoursesModel(status: true, data: [], msg: ''),
              //   future: RemoteDataSourceImpl().getMyCourses(),
              //   builder: (BuildContext context, AsyncSnapshot<MyCoursesModel> snapshot) {
              //     // print(SharedPreferenceHelper.getString(Preferences.getMyCourse));
              //     if (snapshot.hasData) {
              //       if (snapshot.data!.data!.isEmpty) {
              //         return EmptyWidget(
              //           text: Languages.nocourse,
              //           image: SvgImages.emptycourse,
              //         );
              //       } else {
              //         return ListView.builder(
              //           shrinkWrap: true,
              //           itemCount: snapshot.data!.data!.length,
              //           itemBuilder: (context, index) => Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: _myCoursesCardWidget(
              //               context,
              //               snapshot.data!.data![index],
              //             ),
              //           ),
              //         );
              //       }
              //     } else {
              //       return Center(
              //           child: SizedBox(
              //         height: MediaQuery.of(context).size.height * 0.6,
              //         width: MediaQuery.of(context).size.width * 0.8,
              //         child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"),
              //       ));
              //     }
              //   },
              // ),
              BlocBuilder<CoursefilterCubit, CoursefilterState>(
                  bloc: context.read<CoursefilterCubit>(),
                  builder: (context, state) {
                    if (state is CourseStreamSelected) {
                      try {
                        scrollController.position.jumpTo(
                          scrollController.position.minScrollExtent,
                          // duration: Duration(milliseconds: 100),
                          // curve: Curves.linear,
                        );
                      } catch (e) {
                        // print(e);
                      }
                      selectedSubject = state.selected;
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<StreamsetectCubit, StreamsetectState>(
                          builder: (context, state) {
                            if (state is TopCourseStreamSelected) {
                              fselectedSubject = SubCategories(title: "ALL");
                              selectedSubject = SubCategories(title: "ALL");
                              getstream();
                              context.read<CoursefilterCubit>().updateState();
                            }
                            return Visibility(
                              visible: isVisable,
                              // maintainAnimation: true,
                              // maintainState: true,
                              // duration: const Duration(milliseconds: 200),
                              // height: isVisable ? 150 : 0,
                              child: const SliderWidget(),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: subjectwidget(),
                          ),
                        ),
                        FutureBuilder<CoursesModel>(
                            // initialData: SharedPreferenceHelper.getString(Preferences.getCourse) != 'N/A' ? CoursesModel.fromJson(jsonDecode(SharedPreferenceHelper.getString(Preferences.getCourse)!)) : CoursesModel(data: [], status: true, msg: ''),
                            future: RemoteDataSourceImpl().getpaidCourses(
                              stream: context.read<StreamsetectCubit>().selectStreamuser ?? "all",
                              subCategory: selectedSubject.id,
                            ),
                            builder: (BuildContext context, AsyncSnapshot<CoursesModel> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SingleChildScrollView(
                                  child: SizedBox(
                                    height: 300,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              }
                              if (snapshot.hasData) {
                                List<CoursesDataModel> filterdata = snapshot.data!.data;

                                // _tabController!.animateTo(SharedPreferenceHelper.getInt(Preferences.selectedStream));
                                // SharedPreferenceHelper.setInt(Preferences.selectedStream, 0);
                                return filterdata.isEmpty
                                    ? SizedBox(
                                        height: 300,
                                        child: Center(
                                          child: EmptyWidget(image: SvgImages.emptycourse, text: Preferences.appString.noCourses ?? Languages.nocourse),
                                        ),
                                      )
                                    : Expanded(
                                        child: CourseBodyDataWidget(
                                        scrollController: scrollController,
                                        courseData: filterdata,
                                        ispaid: true,
                                        currentStreem: context.read<StreamsetectCubit>().selectStreamuser ?? "all",
                                        subcurrentStreem: selectedSubject.id,
                                      ));
                              } else {
                                return Center(
                                    child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.6,
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"),
                                ));
                              }
                            }),
                      ],
                    );
                  }),
              BlocBuilder<CoursefilterCubit, CoursefilterState>(
                builder: (context, state) {
                  if (state is FCourseStreamSelected) {
                    try {
                      fscrollController.position.jumpTo(
                        fscrollController.position.minScrollExtent,
                      );
                    } catch (e) {
                      // print(e);
                    }
                    fselectedSubject = state.selected;
                  }
                  if (state is TopCourseStreamSelected) {
                    fselectedSubject = SubCategories(title: "ALL");
                    selectedSubject = SubCategories(title: "ALL");
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<StreamsetectCubit, StreamsetectState>(builder: (context, state) {
                        if (state is TopCourseStreamSelected) {
                          fselectedSubject = SubCategories(title: "ALL");
                          selectedSubject = SubCategories(title: "ALL");
                          getstream();
                          context.read<CoursefilterCubit>().updateState();
                        }
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: Visibility(visible: isFvisable, child: const SliderWidget()),
                        );
                      }),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: subjectwidget(),
                        ),
                      ),
                      FutureBuilder<CoursesModel>(
                          // initialData: SharedPreferenceHelper.getString(Preferences.getCourse) != 'N/A' ? CoursesModel.fromJson(jsonDecode(SharedPreferenceHelper.getString(Preferences.getCourse)!)) : CoursesModel(data: [], status: true, msg: ''),
                          future: RemoteDataSourceImpl().getfreeCourses(stream: context.read<StreamsetectCubit>().selectStreamuser ?? "all", subCategory: fselectedSubject.id),
                          builder: (BuildContext context, AsyncSnapshot<CoursesModel> snapshot) {
                            // if (snapshot.connectionState == ConnectionState.waiting) {
                            //   return Center(
                            //     child: CircularProgressIndicator(),
                            //   );
                            // }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(
                                height: 300,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              List<CoursesDataModel> filterdata = snapshot.data?.data ?? [];

                              // _tabController!.animateTo(SharedPreferenceHelper.getInt(Preferences.selectedStream));
                              // SharedPreferenceHelper.setInt(Preferences.selectedStream, 0);
                              return filterdata.isEmpty
                                  ? SizedBox(
                                      height: 300,
                                      child: Center(
                                        child: EmptyWidget(image: SvgImages.emptycourse, text: Preferences.appString.noCourses ?? Languages.nocourse),
                                      ),
                                    )
                                  : Expanded(
                                      child: CourseBodyDataWidget(
                                      scrollController: fscrollController,
                                      courseData: filterdata,
                                      ispaid: false,
                                      currentStreem: context.read<StreamsetectCubit>().selectStreamuser ?? "all",
                                      subcurrentStreem: fselectedSubject.id,
                                    ));
                            } else {
                              return Center(
                                  child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.6,
                                // width:
                                //     MediaQuery.of(context).size.width * 0.8,
                                // child: ErrorWidgetapp(
                                //     image: SvgImages.error404,
                                //     text: "Page not found"),
                              ));
                            }
                          })
                    ],
                  );
                },
              )
            ]))
          ],
        ),
      ),
    );
  }

  List<Widget> subjectwidget() {
    List<Widget> listsubject = [];
    for (var element in subject) {
      listsubject.add(
        Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            backgroundColor: Colors.transparent,
            selectedColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: _tabController!.index == 0
                      ? selectedSubject.title?.contains(element.title ?? "") ?? false
                          ? ColorResources.buttoncolor
                          : ColorResources.gray.withValues(alpha: 0.5)
                      : fselectedSubject.title?.contains(element.title ?? "") ?? false
                          ? ColorResources.buttoncolor
                          : ColorResources.gray.withValues(alpha: 0.5),
                )),
            labelStyle: GoogleFonts.notoSansDevanagari(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _tabController!.index == 0
                  ? selectedSubject.title?.contains(element.title ?? "") ?? false
                      ? ColorResources.buttoncolor
                      : ColorResources.textblack.withValues(alpha: 0.6)
                  : fselectedSubject.title?.contains(element.title ?? "") ?? false
                      ? ColorResources.buttoncolor
                      : ColorResources.textblack.withValues(alpha: 0.6),
            ),
            label: Text(
              element.title ?? "",
            ),
            selected: _tabController!.index == 0 ? selectedSubject == element : fselectedSubject == element,
            onSelected: (value) {
              if (_tabController!.index == 0) {
                selectedSubject = context.read<CoursefilterCubit>().courseStreamSelected(selected: element);
              } else {
                fselectedSubject = context.read<CoursefilterCubit>().fCourseStreamSelected(selected: element);
              }
            },
          ),
        ),
      );
    }
    return listsubject;
  }

  // Center _myCoursesCardWidget(BuildContext context, MyCoursesDataModel courseData) {
  //   return Center(
  //     child: Container(
  //       width: MediaQuery.of(context).size.width * 0.90,
  //       decoration: BoxDecoration(
  //         color: ColorResources.textWhite,
  //         boxShadow: const [
  //           BoxShadow(
  //             color: Colors.grey,
  //             blurRadius: 5.0,
  //           ),
  //         ],
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   courseData.batchDetails!.batchName!,
  //                   style: GoogleFonts.notoSansDevanagari(
  //                     color: ColorResources.textblack,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //                 Align(
  //                   alignment: Alignment.center,
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(10),
  //                     child: CachedNetworkImage(
  //                       imageUrl: courseData.batchDetails!.banner![0].fileLoc!,
  //                       placeholder: (context, url) => Center(
  //                         child: ShimmerCustom.rectangular(height: 100),
  //                       ),
  //                       errorWidget: (context, url, error) => const Icon(Icons.error),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 Row(
  //                   children: [
  //                     const Icon(
  //                       Icons.calendar_month_outlined,
  //                       size: 15,
  //                     ),
  //                     Text.rich(
  //                       TextSpan(
  //                         children: [
  //                           TextSpan(
  //                             text: ' Starts on ',
  //                             style: GoogleFonts.notoSansDevanagari(
  //                               color: ColorResources.textBlackSec,
  //                               fontSize: 10,
  //                               fontWeight: FontWeight.w400,
  //                             ),
  //                           ),
  //                           TextSpan(
  //                             text: courseData.batchDetails!.startingDate,
  //                             style: GoogleFonts.notoSansDevanagari(
  //                               color: ColorResources.textblack,
  //                               fontSize: 10,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                           TextSpan(
  //                             text: '  | ',
  //                             style: GoogleFonts.notoSansDevanagari(
  //                               color: ColorResources.textBlackSec,
  //                               fontSize: 10,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                           TextSpan(
  //                             text: "End's on ",
  //                             style: GoogleFonts.notoSansDevanagari(
  //                               color: ColorResources.textBlackSec,
  //                               fontSize: 10,
  //                               fontWeight: FontWeight.w400,
  //                             ),
  //                           ),
  //                           TextSpan(
  //                             text: courseData.batchDetails!.endingDate,
  //                             style: GoogleFonts.notoSansDevanagari(
  //                               color: ColorResources.textblack,
  //                               fontSize: 10,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               if (courseData.isActive!) {
  //                 Navigator.of(context).push(
  //                   MaterialPageRoute(
  //                     builder: (context) => CourseViewScreen(
  //                       lecture: courseData.lectureDetails!,
  //                       batch: courseData.batchDetails!,
  //                       index: 0,
  //                     ),
  //                   ),
  //                 );
  //               }
  //             },
  //             child: Container(
  //               width: double.infinity,
  //               padding: const EdgeInsets.all(5),
  //               alignment: Alignment.center,
  //               decoration: BoxDecoration(
  //                   borderRadius: const BorderRadius.vertical(
  //                     bottom: Radius.circular(10),
  //                   ),
  //                   // boxShadow: const [
  //                   //   BoxShadow(
  //                   //     color: Colors.grey,
  //                   //     blurRadius: 5.0,
  //                   //     offset: Offset(2, 0),
  //                   //   ),
  //                   // ],
  //                   color: ColorResources.buttoncolor),
  //               child: const Text(
  //                 'Let’s Study',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Container shimmercardwidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ColorResources.textWhite,
        boxShadow: [
          BoxShadow(
            color: ColorResources.gray.withValues(alpha: 0.5),
            blurRadius: 5.0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ShimmerCustom.rectangular(height: 22),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const ShimmerCustom.circular(
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ShimmerCustom.rectangular(
                    height: 12,
                    width: 30,
                  )
                ],
              ),
              Column(
                children: [
                  const ShimmerCustom.circular(
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ShimmerCustom.rectangular(
                    height: 12,
                    width: 30,
                  )
                ],
              ),
              Column(
                children: [
                  const ShimmerCustom.circular(
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ShimmerCustom.rectangular(
                    height: 12,
                    width: 30,
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ShimmerCustom.rectangular(
            height: 20,
            width: MediaQuery.of(context).size.width * 0.5,
          )
        ],
      ),
    );
  }
}
