import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';
import 'package:sd_campus_app/features/data/remote/models/recorded_video_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/resourcespdfwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/videopaler.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/batch_feature.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/util/showcase_tour.dart';
import 'package:sd_campus_app/view/screens/course/courseview.dart';
import 'package:showcaseview/showcaseview.dart';

class VideoCatListScreen extends StatefulWidget {
  final String name;
  final String batchId;
  final List<BatchFeatureEnum> features;
  final String subjectId;
  const VideoCatListScreen({
    super.key,
    required this.name,
    required this.batchId,
    required this.subjectId,
    required this.features,
  });

  @override
  State<VideoCatListScreen> createState() => _VideoCatListScreenState();
}

class _VideoCatListScreenState extends State<VideoCatListScreen> {
  List<Widget> tabs = [];
  List<Widget> tabViews = [];
  List<GlobalKey> tabKeys = [];
  @override
  void initState() {
    super.initState();
    // safeSetState(() {
    for (var e in widget.features) {
      if (e == BatchFeatureEnum.lecture) {
        tabs.add(
          Tab(
              child: Showcase(
                  titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                  key: lectureVideoTab,
                  title: Preferences.apptutor.lectureVideoTab?.title,
                  description: Preferences.apptutor.lectureVideoTab?.des ?? " Lecture Videos",
                  targetPadding: EdgeInsets.all(10),
                  child: Text(
                    Preferences.appString.lectureVideos ?? 'Lecture Videos',
                  ))),
        );
        tabViews.add(_lecturetab());
        tabKeys.add(lectureVideoTab);
      } else if (e == BatchFeatureEnum.note) {
        tabs.add(
          Tab(
            child: Showcase(
              titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
              key: notesTab,
              targetPadding: EdgeInsets.all(10),
              title: Preferences.apptutor.notesTab?.title,
              description: Preferences.apptutor.notesTab?.des ?? " Notes",
              child: Text(Preferences.appString.notes ?? 'Notes'),
            ),
          ),
        );
        tabViews.add(
          BatchNotesWidget(
            batchId: widget.batchId,
            subjectId: widget.subjectId,
          ),
        );
        tabKeys.add(notesTab);
      } else if (e == BatchFeatureEnum.dpp) {
        tabs.add(
          Tab(
            child: Showcase(
              titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
              key: dppsTab,
              targetPadding: EdgeInsets.all(10),
              title: Preferences.apptutor.dppsTab?.title,
              description: Preferences.apptutor.dppsTab?.des ?? "DPP's",
              child: Text(Preferences.appString.dPPs ?? 'DPP`s'),
            ),
          ),
        );
        tabViews.add(_dpptab());
        tabKeys.add(dppsTab);
      }
    }
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<String> keys = SharedPreferenceHelper.getStringList(Preferences.showTour);
      if (!keys.contains(Preferences.lectureTabCourseScreenTour)) {
        SharedPreferenceHelper.setStringList(Preferences.showTour, keys..add(Preferences.lectureTabCourseScreenTour));
        ShowCaseWidget.of(context).startShowCase(tabKeys);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: "app_video_rec_subject_screen",
      screenClass: "VideoCatListScreen",
      parameters: {
        "name_sbuject": widget.name,
        "date": DateTime.now().toString(),
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(
            color: ColorResources.textblack,
          ),
        ),
        elevation: 0,
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(
          color: ColorResources.textblack,
        ),
      ),
      body: DefaultTabController(
        length: tabs.length,
        child: Column(children: <Widget>[
          if (tabs.length > 1)
            Container(
                constraints: const BoxConstraints.expand(height: 50),
                color: Colors.white,
                child: TabBar(
                  indicatorColor: ColorResources.buttoncolor,
                  labelColor: ColorResources.buttoncolor,
                  unselectedLabelColor: ColorResources.textblack.withValues(alpha: 0.6),
                  tabs: tabs,
                )),
          Expanded(
            child: TabBarView(
              children: tabViews,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _lecturetab() {
    return FutureBuilder<List<LectureDetails>>(
        future: RemoteDataSourceImpl().getLecturesOfSubject(batchId: widget.batchId, subjectId: widget.subjectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: snapshot.data!.isEmpty
                    ? EmptyWidget(image: SvgImages.emptyCourseVideo, text: Preferences.appString.noVideos ?? Languages.novideo)
                    : ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 5,
                        ),
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => infoCardWidget(lecture: snapshot.data![index], context: context),
                      ),
              );
            } else {
              // print(snapshot.error);
              return Center(
                child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _dpptab() {
    return FutureBuilder(
      future: RemoteDataSourceImpl().getbatchdppByidRequest(
        id: widget.batchId,
        subjectId: widget.subjectId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Align(
              alignment: Alignment.topCenter,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: snapshot.data?.data?.isEmpty ?? true
                    ? EmptyWidget(image: SvgImages.dppNoteslive, text: Preferences.appString.noDPPs ?? "There is no DPP")
                    : ListView.builder(
                        itemCount: snapshot.data?.data?.length ?? 0,
                        itemBuilder: (context, index) => Card(
                          color: Colors.white,
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
                                  snapshot.data!.data![index].lectureTitle!,
                                  style: TextStyle(
                                    color: ColorResources.textblack,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ResourcesContainerWidget(
                                  title: snapshot.data!.data![index].file!.fileName!,
                                  uploadFile: snapshot.data!.data![index].file!.fileLoc!,
                                  resourcetype: 'pdf',
                                  fileSize: snapshot.data!.data![index].file!.fileSize!,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            );
          } else {
            return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _recordedVideoWidget(Listofvideos videosdata) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayVideoFromNetwork(videourl: videosdata.fileUrl!.fileLoc!),
          ),
        );
        //download(videosdata.fileUrl!.fileLoc!, videosdata.title);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorResources.borderColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                height: 60,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorResources.gray,
                ),
                child: Icon(Icons.play_circle, color: ColorResources.textWhite),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                videosdata.title!,
                style: GoogleFonts.notoSansDevanagari(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
