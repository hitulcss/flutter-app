import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/gettestresult.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/prgress.dart';
import 'package:sd_campus_app/features/presentation/widgets/roundedtext.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/pdf_render.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/bottomnav/quiz/summery_screen.dart';

class TestResultScreen extends StatelessWidget {
  final String title;
  final String id;
  final bool isObjective;
  const TestResultScreen({super.key, required this.title, required this.id, required this.isObjective});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          title,
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
          ),
        ),
      ),
      body: FutureBuilder<GetTestResultsModel>(
        future: RemoteDataSourceImpl().getTestResults(id: id),
        builder: (BuildContext context, AsyncSnapshot<GetTestResultsModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return isObjective
                  ? DefaultTabController(
                      length: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            constraints: const BoxConstraints.expand(height: 50),
                            child: TabBar(indicatorColor: ColorResources.buttoncolor, labelColor: ColorResources.buttoncolor, unselectedLabelColor: Colors.black, tabs: [
                              Tab(text: Languages.offlinetest),
                              Tab(text: Languages.onlineTest),
                            ]),
                          ),
                          Expanded(
                            child: TabBarView(physics: const NeverScrollableScrollPhysics(), children: [
                              FractionallySizedBox(
                                widthFactor: 0.95,
                                child: snapshot.data!.data!.objective!.offline!.isEmpty
                                    ? EmptyWidget(image: SvgImages.emptytestseries, text: Languages.notestseries)
                                    : ListView.separated(
                                        separatorBuilder: (context, index) => const SizedBox(
                                          height: 5,
                                        ),
                                        itemCount: snapshot.data!.data!.objective!.offline!.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return offlineCard(
                                            context: context,
                                            date: snapshot.data!.data!.objective!.offline![index].attemptedAt!,
                                            titleName: snapshot.data!.data!.objective!.offline![index].testTitle!,
                                            checkedAnsFile: snapshot.data!.data!.objective!.offline![index].checkedAnswerSheet!.fileLoc!,
                                            youAnsFile: snapshot.data!.data!.objective!.offline![index].answerSheet!.fileLoc!,
                                            score: snapshot.data!.data!.objective!.offline![index].score!,
                                            totalMarks: snapshot.data!.data!.objective!.offline![index].totalMarks!,
                                          );
                                        },
                                      ),
                              ),
                              FractionallySizedBox(
                                widthFactor: 0.95,
                                child: snapshot.data!.data!.objective!.online!.isEmpty
                                    ? EmptyWidget(image: SvgImages.emptytestseries, text: Languages.notestseries)
                                    : ListView.separated(
                                        separatorBuilder: (context, index) => const SizedBox(
                                          height: 5,
                                        ),
                                        itemCount: snapshot.data!.data!.objective!.online!.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return onlineCard(
                                            context: context,
                                            date: snapshot.data!.data!.objective!.online![index].attemptedAt!,
                                            titleName: snapshot.data!.data!.objective!.online![index].testTitle!,
                                            id: snapshot.data!.data!.objective!.online![index].testId!,
                                            isPublish: snapshot.data!.data!.objective!.online![index].isResultPublished!,
                                            totalMarks: snapshot.data!.data!.objective!.online![index].totalMarks!,
                                            attemptId: snapshot.data!.data!.objective!.online![index].id!,
                                          );
                                        },
                                      ),
                              ),
                            ]),
                          )
                        ],
                      ),
                    )
                  : FractionallySizedBox(
                      widthFactor: 0.95,
                      child: snapshot.data!.data!.objective!.offline!.isEmpty
                          ? EmptyWidget(image: SvgImages.emptytestseries, text: Languages.notestseries)
                          : ListView.separated(
                              separatorBuilder: (context, index) => const SizedBox(
                                height: 5,
                              ),
                              itemCount: snapshot.data!.data!.objective!.offline!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return offlineCard(
                                  context: context,
                                  date: snapshot.data!.data!.subjective!.offline![index].attemptedAt!,
                                  titleName: snapshot.data!.data!.subjective!.offline![index].testTitle!,
                                  checkedAnsFile: snapshot.data!.data!.subjective!.offline![index].checkedAnswerSheet!.fileLoc!,
                                  youAnsFile: snapshot.data!.data!.subjective!.offline![index].answerSheet!.fileLoc!,
                                  score: snapshot.data!.data!.subjective!.offline![index].score!,
                                  totalMarks: snapshot.data!.data!.subjective!.offline![index].totalMarks!,
                                );
                              },
                            ),
                    );
            } else {
              return ErrorWidgetapp(image: SvgImages.error404, text: "no data found");
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget onlineCard({
    required BuildContext context,
    required String titleName,
    required String date,
    required String totalMarks,
    required bool isPublish,
    required String id,
    required String attemptId,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(15),
      //   color: ColorResources.textWhite,
      //   boxShadow: [
      //     BoxShadow(
      //       color: ColorResources.borderColor,
      //       blurRadius: 20,
      //       offset: Offset(0, 4),
      //     )
      //   ],
      // ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleName,
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textblack,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    date,
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textblack,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${Languages.score}: 0/$totalMarks',
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textblack,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  resultfunction(context: context, id: id, attemptId: attemptId, name: titleName);
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorResources.buttoncolor,
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        color: ColorResources.textWhite,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      Languages.viewResult,
                      style: GoogleFonts.notoSansDevanagari(
                        color: ColorResources.buttoncolor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget offlineCard({
    required BuildContext context,
    required String titleName,
    required String date,
    required String checkedAnsFile,
    required String youAnsFile,
    required String totalMarks,
    required String score,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleName,
                        style: GoogleFonts.notoSansDevanagari(
                          color: ColorResources.textblack,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        date,
                        style: GoogleFonts.notoSansDevanagari(
                          color: ColorResources.textblack,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorResources.buttoncolor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            score,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        Text(
                          Languages.score,
                          style: GoogleFonts.notoSansDevanagari(
                            color: ColorResources.textblack,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            youAnsFile.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: ColorResources.borderColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        Languages.youranswersheet,
                        style: GoogleFonts.notoSansDevanagari(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: ColorResources.textblack,
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PdfRenderScreen(
                              name: titleName,
                              filePath: youAnsFile,
                              isoffline: false,
                            ),
                          ));
                          // flutterToast("downloading..");
                          // download(widget.data.answerTemplate!.fileLoc, widget.data.answerTemplate!.fileName);
                          // launchUrl(
                          //     Uri.parse(
                          //         widget.data.answerTemplate!.fileLoc!),
                          //     mode: LaunchMode.externalApplication);
                        },
                        child: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: ColorResources.buttoncolor,
                          child: Icon(
                            Icons.file_download_outlined,
                            size: 25,
                            color: ColorResources.textWhite,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            checkedAnsFile.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: ColorResources.borderColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        Languages.checkedAnswer,
                        style: GoogleFonts.notoSansDevanagari(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: ColorResources.textblack,
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PdfRenderScreen(
                              name: titleName,
                              filePath: checkedAnsFile,
                              isoffline: false,
                            ),
                          ));
                          // flutterToast("downloading..");
                          // download(widget.data.answerTemplate!.fileLoc, widget.data.answerTemplate!.fileName);
                          // launchUrl(
                          //     Uri.parse(
                          //         widget.data.answerTemplate!.fileLoc!),
                          //     mode: LaunchMode.externalApplication);
                        },
                        child: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: ColorResources.buttoncolor,
                          child: Icon(
                            Icons.file_download_outlined,
                            size: 25,
                            color: ColorResources.textWhite,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  resultfunction({required BuildContext context, required String id, required String attemptId, required String name}) {
    Preferences.onLoading(context);
    RemoteDataSourceImpl().getrResultById(id, attemptId).then(
      (response) {
        Preferences.hideDialog(context);
        if (response.status!) {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            //backgroundColor: Colors.white,
            clipBehavior: Clip.hardEdge,
            builder: (context) {
              return StatefulBuilder(
                builder: (BuildContext context, safeSetState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      response.data!.isPublished!
                          ? Container()
                          : const SizedBox(
                              height: 15,
                            ),
                      response.data!.isPublished!
                          ? Container(
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: ColorResources.textWhite,
                                gradient: LinearGradient(stops: const [
                                  0.015,
                                  0.015
                                ], colors: [
                                  ColorResources.buttoncolor,
                                  Colors.white
                                ]),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorResources.gray.withValues(alpha: 0.5),
                                    blurRadius: 5.0,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.emoji_events,
                                          size: 35,
                                          color: Colors.yellow[800],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          Preferences.appString.testPerformance ?? "Test Performance",
                                          style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.bold, color: ColorResources.textblack, fontSize: 20.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        ProgressbarWidget(
                                          center: response.data!.myScore!.number!,
                                          footer: '${double.parse(response.data!.myScore!.number!)}/${response.data!.totalMarks!.split('.')[0]}',
                                          percent: (double.parse(response.data!.myScore!.percentage!)).abs(),
                                          radius: MediaQuery.of(context).size.width * 0.10,
                                        ),
                                        ProgressbarWidget(
                                          center: "${response.data!.accuracy!.number}%",
                                          footer: Preferences.appString.accuracy ?? Languages.accuracy,
                                          percent: (double.parse(response.data!.accuracy!.percentage!)).abs(),
                                          radius: MediaQuery.of(context).size.width * 0.10,
                                        ),
                                        ProgressbarWidget(
                                          center: response.data!.toperScore!.number!,
                                          footer: Preferences.appString.topperScore ?? Languages.topperScore,
                                          percent: (double.parse(response.data!.toperScore!.percentage!)).abs(),
                                          radius: MediaQuery.of(context).size.width * 0.10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      response.data!.isPublished!
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RounderTextwidget(
                                  backgroundcolor: const Color(0XFF37AEE2),
                                  center: response.data!.summary!.noOfQues.toString(),
                                  centertextcolor: ColorResources.textWhite,
                                  footer: Languages.total,
                                ),
                                RounderTextwidget(
                                  backgroundcolor: const Color(0XFFFFB800),
                                  center: response.data!.summary!.attempted.toString(),
                                  centertextcolor: ColorResources.textWhite,
                                  footer: Languages.attempted,
                                ),
                                RounderTextwidget(
                                  backgroundcolor: const Color(0XFF57D163),
                                  center: response.data!.summary!.correctAns.toString(),
                                  centertextcolor: ColorResources.textWhite,
                                  footer: Languages.correctness,
                                ),
                                RounderTextwidget(
                                  backgroundcolor: const Color(0XFFFB5259),
                                  center: response.data!.summary!.wrongAnswers.toString(),
                                  centertextcolor: ColorResources.textWhite,
                                  footer: Languages.incorrect,
                                ),
                                RounderTextwidget(
                                  backgroundcolor: const Color(0XFFBBE3FF),
                                  center: response.data!.summary!.skipped.toString(),
                                  centertextcolor: ColorResources.textblack,
                                  footer: Languages.skipped,
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RounderTextwidget(
                                  backgroundcolor: const Color(0XFF37AEE2),
                                  center: response.data!.summary!.noOfQues.toString(),
                                  centertextcolor: ColorResources.textWhite,
                                  footer: Languages.total,
                                ),
                                RounderTextwidget(
                                  backgroundcolor: const Color(0XFFFFB800),
                                  center: response.data!.summary!.attempted.toString(),
                                  centertextcolor: ColorResources.textWhite,
                                  footer: Languages.attempted,
                                ),
                                RounderTextwidget(
                                  backgroundcolor: const Color(0XFFBBE3FF),
                                  center: response.data!.summary!.skipped.toString(),
                                  centertextcolor: ColorResources.textblack,
                                  footer: Languages.skipped,
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (response.data!.isPublished!) {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => SummaryScreen(
                                      name: name,
                                      data: response.data,
                                    )));
                          }
                          //else{
                          //  fluttert("Result not publish yet...")
                          //}
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          color: response.data!.isPublished! ? ColorResources.buttoncolor : ColorResources.gray,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              response.data!.isPublished! ? Preferences.appString.viewDetailAnalysis ?? Languages.viewDetailedAnalysis : Preferences.appString.reslutNotYetPublished ?? Languages.resultnotpublishyet,
                              style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.bold, color: ColorResources.textWhite, fontSize: 18.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            },
          );
        } else {
          flutterToast(response.msg!);
        }
      },
    );
  }
}
