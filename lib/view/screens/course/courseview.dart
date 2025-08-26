import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sd_campus_app/api/retrofit_api.dart';
import 'package:sd_campus_app/api/base_model.dart';
import 'package:sd_campus_app/api/network_api.dart';
import 'package:sd_campus_app/api/server_error.dart';
import 'package:sd_campus_app/features/cubit/appstream_cubit/app_stream_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_notes_model.dart';
import 'package:sd_campus_app/features/data/remote/models/get_batch_subject.dart';
import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';
import 'package:sd_campus_app/features/data/remote/models/recorded_video_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/resourcespdfwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/shimmer_custom.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/models/joinstreaming.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/batch_feature.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/localfiles.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:intl/intl.dart';
import 'package:sd_campus_app/util/showcase_tour.dart';
import 'package:sd_campus_app/view/screens/app_stream.dart';
import 'package:sd_campus_app/view/screens/bottomnav/course_before_buy/list_of_announcement.dart';
import 'package:sd_campus_app/view/screens/course/batch_quiz.dart';
import 'package:sd_campus_app/view/screens/course/community/community_tab.dart';
import 'package:sd_campus_app/view/screens/course/doubt/doubts_tab.dart';
import 'package:sd_campus_app/view/screens/course/video_catg_list.dart';
import 'package:sd_campus_app/view/screens/live_class/live_class_lecture.dart';
import 'package:sd_campus_app/view/screens/youtubeclass.dart';
import 'package:share_plus/share_plus.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseViewScreen extends StatefulWidget {
  const CourseViewScreen({
    super.key,
    this.index = BatchFeatureEnum.lecture,
    required this.batchId,
    required this.courseName,
  });

  final String courseName;
  final String batchId;
  final BatchFeatureEnum? index;

  @override
  State<CourseViewScreen> createState() => _CourseViewScreenState();
}

class _CourseViewScreenState extends State<CourseViewScreen> with TickerProviderStateMixin {
  TabController? _tabcontrole;
  final List<Tab> _tablist = [];
  final List<Widget> _tabBody = [];
  final List<GlobalKey> _keysShowcase = [
    mycourseinfo
  ];
  final List<String> tabname = [
    "info"
  ];
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    analytics.logScreenView(screenName: "app_MyCourseView_screen", screenClass: "CourseViewScreen", parameters: {
      "id": widget.batchId,
      "batch_name": widget.courseName,
    });
    _tabcontrole = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabcontrole?.dispose();
    super.dispose();
  }

  void startShowcase() {
    if (!SharedPreferenceHelper.getStringList(Preferences.showTour).contains(Preferences.courseScreenTour)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Ensure the widget is still mounted
          try {
            final showcase = ShowCaseWidget.of(context);
            if (showcase.mounted) {
              // Check if the context is valid
              showcase.startShowCase(_keysShowcase);
              SharedPreferenceHelper.setStringList(
                Preferences.showTour,
                SharedPreferenceHelper.getStringList(Preferences.showTour)..add(Preferences.courseScreenTour),
              );
            }
          } catch (e) {
            debugPrint('Showcase error: $e');
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: RemoteDataSourceImpl().getMyCoursesByid(id: widget.batchId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  _tabBody.clear();
                  _tablist.clear();
                  _keysShowcase.clear();
                  _keysShowcase.add(mycourseinfo);
                  _tablist.add(
                    Tab(
                      child: Showcase(
                        key: mycourseinfo,
                        titleTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        titleAlignment: Alignment.centerLeft,
                        title: Preferences.apptutor.mycourseinfo?.title,
                        description: Preferences.apptutor.mycourseinfo?.des ?? "Info",
                        targetPadding: EdgeInsets.all(10),
                        child: Text(Preferences.appString.info ?? Languages.info),
                      ),
                    ),
                  );
                  _tabBody.add(batchInfo(snapshot.data!));

                  snapshot.data?.batchFeatures?.forEach((element) {
                    if (element.feature == BatchFeatureEnum.lecture.name) {
                      _tablist.add(
                        Tab(
                          child: Showcase(
                            key: mycourseLecture,
                            title: Preferences.apptutor.mycourse?.title,
                            titleTextStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            titleAlignment: Alignment.centerLeft,
                            description: Preferences.apptutor.mycourseLecture?.des ?? "Lecture",
                            targetPadding: EdgeInsets.all(10),
                            child: Text(Preferences.appString.lectures ?? "Lectures "),
                          ),
                        ),
                      );
                      _keysShowcase.add(mycourseLecture);
                      _tabBody.add(
                        CoursesVideoWidget(
                          batchId: widget.batchId,
                        ),
                      );
                      tabname.add(BatchFeatureEnum.lecture.name);
                    } else if (element.feature == BatchFeatureEnum.quiz.name) {
                      _tablist.add(
                        Tab(
                          child: Showcase(
                            key: mycourseTest,
                            titleTextStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            titleAlignment: Alignment.centerLeft,
                            title: Preferences.apptutor.mycourseTest?.title,
                            description: Preferences.apptutor.mycourseTest?.des ?? "Test",
                            targetPadding: EdgeInsets.all(10),
                            child: Text(Preferences.appString.tests ?? "Test"),
                          ),
                        ),
                      );
                      _tabBody.add(BatchQuizScreen(
                        batchId: widget.batchId,
                        isFullScreen: false,
                        isLocked: false,
                      ));
                      _keysShowcase.add(mycourseTest);
                      tabname.add(BatchFeatureEnum.quiz.name);
                    } else if (element.feature == BatchFeatureEnum.announcement.name) {
                      _tablist.add(
                        Tab(
                          child: Showcase(
                            key: mycourseannouncement,
                            titleTextStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            titleAlignment: Alignment.centerLeft,
                            title: Preferences.apptutor.mycourseannouncement?.title,
                            description: Preferences.apptutor.mycourseannouncement?.des ?? "Announcements",
                            targetPadding: EdgeInsets.all(10),
                            child: Text(Preferences.appString.announcements ?? "Announcements"),
                          ),
                        ),
                      );
                      _tabBody.add(ListOfAnnouncementScreen(
                        batchId: widget.batchId,
                        isFullScreen: false,
                      ));
                      tabname.add(BatchFeatureEnum.announcement.name);
                      _keysShowcase.add(mycourseannouncement);
                    } else if (element.feature == BatchFeatureEnum.doubt.name) {
                      _tablist.add(Tab(
                        child: Showcase(
                          key: mycourseDoubt,
                          titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                          title: Preferences.apptutor.mycourseDoubt?.title,
                          description: Preferences.apptutor.mycourseDoubt?.des ?? "Doubt",
                          targetPadding: EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Doubt"),
                              if (Preferences.newFeatures.doubt ?? false)
                                CachedNetworkImage(
                                  imageUrl: SvgImages.newFeature,
                                  height: 16,
                                  errorWidget: (context, url, error) => SizedBox(),
                                )
                            ],
                          ),
                        ),
                      ));
                      _tabBody.add(
                        DoubtsTabWidgetScreen(
                          batchId: widget.batchId,
                          isFullScreen: true,
                          isLocked: false,
                        ),
                      );
                      _keysShowcase.add(mycourseDoubt);
                      tabname.add(BatchFeatureEnum.doubt.name);
                    } else if (element.feature == BatchFeatureEnum.community.name) {
                      _tablist.add(Tab(
                        // text: "Community",
                        child: Showcase(
                          key: mycourseCommunity,
                          titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                          title: Preferences.apptutor.mycourseCommunity?.title,
                          description: Preferences.apptutor.mycourseCommunity?.des ?? "Community",
                          targetPadding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text("Community"),
                              if (Preferences.newFeatures.doubt ?? false)
                                CachedNetworkImage(
                                  imageUrl: SvgImages.newFeature,
                                  height: 16,
                                  errorWidget: (context, url, error) => SizedBox(),
                                )
                            ],
                          ),
                        ),
                      ));
                      _tabBody.add(
                        CommunityTabWidgetScreen(
                          batchId: widget.batchId,
                          isFullScreen: true,
                          isLocked: false,
                        ),
                      );
                      tabname.add(BatchFeatureEnum.community.name);
                      _keysShowcase.add(mycourseCommunity);
                    }
                    for (var element in tabname) {
                      if (widget.index?.name == element) {
                        _tabcontrole?.animateTo(tabname.indexOf(element));
                      }
                    }
                  });
                  _tabcontrole = TabController(length: _tablist.length, vsync: this);
                  startShowcase();
                  return NestedScrollView(
                    controller: _controller,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar.large(
                          expandedHeight: 220,
                          stretch: true,
                          leading: IconButton.filledTonal(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                            ),
                          ),
                          actions: [
                            if (snapshot.data!.shareUrl?.link != null && (snapshot.data?.shareUrl?.link?.isNotEmpty ?? false))
                              IconButton.filledTonal(
                                  onPressed: () {
                                    Share.shareUri(Uri.parse(snapshot.data!.shareUrl?.link ?? ""));
                                  },
                                  icon: const Icon(
                                    Icons.share,
                                  ))
                          ],
                          backgroundColor: ColorResources.textWhite,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: snapshot.data!.banner?[0].fileLoc ?? "",
                                  height: 150,
                                  placeholder: (context, url) => Center(
                                    child: ShimmerCustom.rectangular(height: 100),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  width: double.infinity,
                                  color: ColorResources.textWhite,
                                  child: Text(
                                    snapshot.data?.batchName ?? "",
                                    maxLines: 1,
                                    style: GoogleFonts.notoSansDevanagari(
                                      color: ColorResources.textblack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            snapshot.data?.batchName ?? "",
                            style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
                          ),
                          bottom: TabBar(
                            tabAlignment: TabAlignment.start,
                            controller: _tabcontrole,
                            isScrollable: true,
                            indicatorColor: ColorResources.buttoncolor,
                            labelColor: ColorResources.buttoncolor,
                            unselectedLabelColor: ColorResources.textblack.withValues(alpha: 0.6),
                            onTap: (value) {
                              if (tabname[value] == "info") {
                                analytics.logEvent(name: "app_mycourser_info", parameters: {
                                  "batchid": widget.batchId,
                                  "batch_name": widget.courseName
                                });
                              } else if (tabname[value] == BatchFeatureEnum.lecture.name) {
                                analytics.logEvent(name: "app_mycourser_videos", parameters: {
                                  "batchid": widget.batchId,
                                  "batch_name": widget.courseName
                                });
                              } else if (tabname[value] == BatchFeatureEnum.quiz.name) {
                                analytics.logEvent(name: "app_mycourser_quiz", parameters: {
                                  "batchid": widget.batchId,
                                  "batch_name": widget.courseName
                                });
                              } else if (tabname[value] == BatchFeatureEnum.announcement.name) {
                                analytics.logEvent(name: "app_mycourser_announcements", parameters: {
                                  "batchid": widget.batchId,
                                  "batch_name": widget.courseName
                                });
                              } else if (tabname[value] == BatchFeatureEnum.doubt.name) {
                                _tabcontrole?.animateTo(0);
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => _tabBody[value],
                                    ));

                                analytics.logEvent(name: "app_mycourser_doubt", parameters: {
                                  "batchid": widget.batchId,
                                  "batch_name": widget.courseName
                                });
                              } else if (tabname[value] == BatchFeatureEnum.community.name) {
                                _tabcontrole?.animateTo(0);
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => _tabBody[value],
                                    ));
                                analytics.logEvent(name: "app_mycourser_community", parameters: {
                                  "batchid": widget.batchId,
                                  "batch_name": widget.courseName
                                });
                              }
                            },
                            tabs: _tablist,
                          ),
                        ),
                      ];
                    },
                    body: Column(children: [
                      Expanded(
                        child: TabBarView(controller: _tabcontrole, physics: const NeverScrollableScrollPhysics(), children: _tabBody),
                      ),
                    ]),
                  );
                } else {
                  return ErrorWidgetapp(image: SvgImages.error404, text: "sever not found");
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  batchInfo(MyCoursesDataModel data) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: (data.upcomingLecture?.isEmpty ?? true) && (data.todayLecture?.isEmpty ?? true),
                backgroundColor: Colors.white,
                collapsedBackgroundColor: Colors.white,
                title: Text(
                  Preferences.appString.description ?? "Description",
                  style: TextStyle(
                    color: ColorResources.textblack,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  Html(
                    shrinkWrap: true,
                    data: data.description ?? "",
                    onAnchorTap: (url, attributes, element) {
                      Uri openurl = Uri.parse(url?.trim() ?? "https://www.sdcampus.com");
                      launchUrl(
                        openurl,
                      );
                    },
                  ),
                  data.planner?.fileLoc?.isEmpty ?? true
                      ? Container()
                      : const SizedBox(
                          height: 10,
                        ),
                  data.planner?.fileLoc?.isEmpty ?? true
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ResourcesContainerWidget(
                            title: data.planner?.fileName ?? "",
                            uploadFile: data.planner?.fileLoc ?? "",
                            resourcetype: "pdf",
                            fileSize: "",
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (data.todayLecture?.isNotEmpty ?? false) ...[
              Text(
                Preferences.appString.todayClass ?? "Today’s Classes",
                style: TextStyle(
                  color: ColorResources.textblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              data.todayLecture?.isEmpty ?? true
                  ? Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorResources.textWhite, boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.3),
                          blurRadius: 5.0,
                        ),
                      ]),
                      child: EmptyWidget(
                        image: SvgImages.emptyCourseVideo,
                        text: Preferences.appString.noClasses ?? 'There is no class',
                      ),
                    )
                  : ListView.builder(
                      itemCount: data.todayLecture?.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => infoCardWidget(lecture: data.todayLecture?[index] ?? LectureDetails(), context: context),
                    ),
            ],
            if (data.upcomingLecture?.isNotEmpty ?? false) ...[
              const SizedBox(
                height: 10,
              ),
              Text(
                Preferences.appString.upcomingClass ?? "Upcoming Classes",
                style: TextStyle(
                  color: ColorResources.textblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              data.upcomingLecture?.isEmpty ?? true
                  ? Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorResources.textWhite, boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.3),
                          blurRadius: 5.0,
                        ),
                      ]),
                      child: EmptyWidget(
                        image: SvgImages.emptyCourseVideo,
                        text: Preferences.appString.noClasses ?? 'There is no class',
                      ),
                    )
                  : ListView.builder(
                      itemCount: data.upcomingLecture?.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => infoCardWidget(lecture: data.upcomingLecture?[index] ?? LectureDetails(), context: context),
                    )
            ]
          ],
        ),
      ),
    );
  }
}

class BatchNotesWidget extends StatelessWidget {
  final String batchId;
  final String subjectId;
  const BatchNotesWidget({
    super.key,
    required this.batchId,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context) {
    Localfilesfind.initState();
    RemoteDataSourceImpl batchNotesDataModel = RemoteDataSourceImpl();
    List<BatchNotesModelData>? notesList;
    return FutureBuilder<List<BatchNotesModelData>>(
        initialData: notesList,
        future: batchNotesDataModel.getBatchNotes(batchId: batchId, subjectId: subjectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              notesList = snapshot.data!;
              return notesList!.isEmpty
                  ? EmptyWidget(image: SvgImages.emptycourse, text: Preferences.appString.noResources ?? Languages.noresources)
                  : ListView.builder(
                      itemCount: notesList!.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: batchNotesCard(
                          notesList![index],
                        ),
                      ),
                    );
            } else {
              return Center(
                  child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"),
              ));
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

Widget batchNotesCard(BatchNotesModelData carddata) {
  return Card(
    color: Colors.white,
    surfaceTintColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            carddata.title!,
            style: TextStyle(
              color: ColorResources.textblack,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Divider(),
        carddata.res!.isEmpty
            ? SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    Languages.nodatalecture,
                    style: TextStyle(
                      color: ColorResources.textblack,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: carddata.res!.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ResourcesContainerWidget(
                    resourcetype: carddata.res![index].resourceType!,
                    title: carddata.res![index].resourceTitle!,
                    uploadFile: carddata.res![index].file!.fileLoc!,
                    fileSize: carddata.res![index].file!.fileSize!,
                  ),
                ),
              ),
      ],
    ),
  );
}

class CoursesVideoWidget extends StatefulWidget {
  const CoursesVideoWidget({
    super.key,
    required this.batchId,
  });
  final String batchId;

  @override
  State<CoursesVideoWidget> createState() => _CoursesVideoWidgetState();
}

class _CoursesVideoWidgetState extends State<CoursesVideoWidget> {
  @override
  Widget build(BuildContext context) {
    RemoteDataSourceImpl remoteDataSourceImpl = RemoteDataSourceImpl();
    List<RecordedVideoDataModel>? videoList;
    return FutureBuilder<BatchSubject>(
        future: remoteDataSourceImpl.getSubjectOfBatch(id: widget.batchId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return snapshot.data!.data!.subjects!.isEmpty
                  ? EmptyWidget(image: SvgImages.emptyCourseVideo, text: Languages.novideo)
                  : AlignedGridView.count(
                      padding: const EdgeInsets.all(10),
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.data!.subjects!.length,
                      itemBuilder: (BuildContext context, int index) {
                        List<BatchFeatureEnum> features = [];
                        for (var element in snapshot.data!.data!.batchFeatures!) {
                          if (element.feature == BatchFeatureEnum.lecture.name) {
                            features.add(BatchFeatureEnum.lecture);
                          } else if (element.feature == BatchFeatureEnum.note.name) {
                            features.add(BatchFeatureEnum.note);
                          } else if (element.feature == BatchFeatureEnum.dpp.name) {
                            features.add(BatchFeatureEnum.dpp);
                          }
                        }
                        return recordedvideobody(name: snapshot.data!.data!.subjects![index].title!, subjectId: snapshot.data!.data!.subjects![index].id!, batchId: widget.batchId, icons: snapshot.data!.data!.subjects![index].icon!, features: features);
                      },
                    );
            } else {
              return const Center(child: Text("Something Went Wrong"));
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget recordedvideobody({
    required String name,
    required String subjectId,
    required String batchId,
    required String icons,
    required List<BatchFeatureEnum> features,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => VideoCatListScreen(
            name: name,
            batchId: batchId,
            subjectId: subjectId,
            features: features,
          ),
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorResources.borderColor,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            CachedNetworkImage(
                imageUrl: icons,
                height: 60,
                width: 60,
                fit: BoxFit.fill,
                placeholder: (context, url) => Center(
                      child: ShimmerCustom.rectangular(height: 30),
                    ),
                errorWidget: (context, url, error) => CircleAvatar(
                      child: Text(
                        name[0],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget infoCardWidget({required LectureDetails lecture, required BuildContext context}) {
  final NavigatorState navigator = Navigator.of(context);
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 5),
      onTap: () {
        if (DateFormat("dd-MM-yyyy HH:mm:ss").parse(lecture.startingDate!).difference(DateTime.now()).inDays > 0) {
          analytics.logEvent(name: "app_trying_to_attend_class", parameters: {
            "lectureTitle": lecture.lectureTitle ?? "",
            "Id": lecture.sId ?? "",
          });
          flutterToast('Lecture will start at ${DateFormat("dd MMM yyyy HH:mm a").format(DateFormat("dd-MM-yyyy HH:mm:ss").parse(lecture.startingDate ?? ""))}');
        } else {
          if (lecture.lectureType == "YT") {
            if (DateFormat("dd-MM-yyyy HH:mm:ss").parse(lecture.startingDate!).difference(DateTime.now()).inSeconds < 60) {
              analytics.logEvent(name: "app_class_attend", parameters: {
                "lectureTitle": lecture.lectureTitle ?? "",
                "Id": lecture.sId ?? "",
              });
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => YTClassScreen(
                    lecture: lecture,
                  ),
                ),
              );
            } else {
              analytics.logEvent(name: "app_trying_to_attend_class", parameters: {
                "lectureTitle": lecture.lectureTitle ?? "",
                "Id": lecture.sId ?? "",
              });
              flutterToast('Lecture will start at ${DateFormat.jm().format(DateFormat("HH:mm:ss").parse(lecture.startingDate?.split(" ").last ?? ""))}');
            }
          } else if (lecture.lectureType == "TWOWAY") {
            [
              Permission.camera,
              Permission.microphone,
              Permission.bluetooth,
              Permission.bluetoothConnect
            ].request().then((value) async {
              if (await Permission.camera.isGranted && await Permission.microphone.isGranted) {
                if (DateFormat("dd-MM-yyyy HH:mm:ss").parse(lecture.startingDate!).difference(DateTime.now()).inSeconds < 60) {
                  if (lecture.roomDetails?.mentor?.isEmpty ?? true) {
                    analytics.logEvent(name: "no mentor", parameters: {
                      "name": lecture.roomDetails?.batchName ?? "batch name",
                      "id": lecture.roomDetails?.id ?? "batch id",
                    });
                    flutterToast("no menters available");
                  } else {
                    navigator.push(MaterialPageRoute(
                        builder: (context) => LiveClassLecture(
                              lecture: lecture,
                              batch: lecture.roomDetails?.batchName ?? "",
                              roomName: lecture.roomDetails?.title ?? "",
                              name: SharedPreferenceHelper.getString(Preferences.name)!,
                              url: lecture.socketUrl ?? "",
                              mentor: lecture.roomDetails?.mentor?.first.mentorName ?? "",
                              token: SharedPreferenceHelper.getString(Preferences.accesstoken) ?? "",
                            )));
                  }
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
                  child: JoinStreamingScreen(lecture: lecture),
                ),
              ),
            );
          }
        }
      },
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
            (DateFormat("dd-MM-yyyy HH:mm:ss").parse(lecture.startingDate!).difference(DateTime.now()).inDays > 0)
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
          SizedBox()
        ],
      ),
    ),
  );
}

Future<BaseModel<JoinStreaming>> callApiJoinStreamingScreen(LectureDetails lecture, BuildContext context) async {
  JoinStreaming response;
  var random = Random();
  int uid = random.nextInt(999);
  Map<String, dynamic> body = {
    "channelName": lecture.lectureTitle,
    "expireTime": "3600",
    "tokentype": "uid",
    "Stream_title": "Mahadeva@12546987",
    "account": "askd",
    "Description": lecture.description,
    "uid": uid.toString()
  };

  Preferences.onLoading(context);

  try {
    String acessToken = SharedPreferenceHelper.getString(Preferences.accesstoken).toString();
    response = await RestClient(RetroApi().dioData(acessToken)).joinmeetingRequest(body);

    if (response.status!) {
      Preferences.hideDialog(context);
      Fluttertoast.showToast(
        msg: '${response.msg}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorResources.gray,
        textColor: ColorResources.textWhite,
      );
    } else {
      Preferences.hideDialog(context);
      Fluttertoast.showToast(
        msg: '${response.msg}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorResources.gray,
        textColor: ColorResources.textWhite,
      );
    }
  } catch (error) {
    Preferences.hideDialog(context);
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}
