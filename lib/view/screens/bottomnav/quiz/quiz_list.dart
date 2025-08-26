import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/listofquiz.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/prgress.dart';
import 'package:sd_campus_app/features/presentation/widgets/roundedtext.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/appstring.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/bottomnav/quiz/summery_screen.dart';
import 'package:sd_campus_app/view/screens/library/quiz/quiz_detail_screen.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          Languages.dailyEditorialBasedQuiz,
          //'Editorial based quiz',
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<ListOfQuizModel>(
        future: RemoteDataSourceImpl().getListOfQuiz(),
        builder: (context, snapshot) {
          analytics.logScreenView(screenName: "app_daily_quiz", screenClass: "QuizListScreen");
          if (ConnectionState.done == snapshot.connectionState) {
            if (snapshot.hasData) {
              //ListOfQuizModel? response = snapshot.data;
              if (snapshot.data!.status!) {
                return snapshot.data!.data!.notAttempted!.isEmpty && snapshot.data!.data!.isAttempted!.isEmpty
                    ? EmptyWidget(image: SvgImages.emptyquiz, text: Languages.todaysQuizisempty)
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            snapshot.data!.data!.notAttempted!.isNotEmpty
                                ? body(quizdata: snapshot.data!.data!, isAttempted: false)
                                : Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      height: MediaQuery.of(context).size.height * 0.3,
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                          offset: const Offset(2, 3),
                                        ),
                                      ]),
                                      child: EmptyWidget(image: SvgImages.emptyquiz, text: Languages.todaysQuizisempty),
                                    ),
                                  ),
                            snapshot.data!.data!.isAttempted!.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 30.0, top: 20),
                                    child: Text(
                                      Languages.attemptedQuiz,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : Container(),
                            snapshot.data!.data!.isAttempted!.isNotEmpty ? body(quizdata: snapshot.data!.data!, isAttempted: true) : Container(),
                          ],
                        ),
                      );
              } else {
                return Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.6, width: MediaQuery.of(context).size.width * 0.8, child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found")));
              }
            } else {
              return Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.6, width: MediaQuery.of(context).size.width * 0.8, child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"))
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
    );
  }

  Widget body({required ListOfQuizModelData quizdata, required bool isAttempted}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: isAttempted ? quizdata.isAttempted!.length : quizdata.notAttempted!.length,
        itemBuilder: (BuildContext context, int index) {
          return quizcard(context, isAttempted ? quizdata.isAttempted![index] : quizdata.notAttempted![index], isAttempted);
        },
      ),
    );
  }

  Widget quizcard(BuildContext context, quizModelData, bool isAttempted) {
    return Container(
      height: 130,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          spreadRadius: 2,
          blurRadius: 8,
          offset: const Offset(2, 3),
        ),
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: isAttempted
                      ? Border(
                          left: BorderSide(
                            width: 5.0,
                            color: ColorResources.buttoncolor,
                            style: BorderStyle.solid,
                          ),
                        )
                      : const Border(
                          left: BorderSide.none,
                        ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _iconTextWidget('${quizModelData.noQues} ${Languages.questions}', Icons.menu),
                    _iconTextWidget('${(double.parse(quizModelData.eachQueMarks) * int.parse(quizModelData.noQues).toInt())} ${Languages.marks}', Icons.verified_outlined),
                    _iconTextWidget('${quizModelData.quizDuration} Min', Icons.alarm)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: isAttempted
                      ? Border(
                          left: BorderSide(
                            width: 5.0,
                            color: ColorResources.buttoncolor,
                            style: BorderStyle.solid,
                          ),
                        )
                      : const Border(
                          left: BorderSide.none,
                        ),
                  color: ColorResources.borderColor.withValues(alpha: 0.2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            quizModelData.quizTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.notoSansDevanagari(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: ColorResources.textblack,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            isAttempted
                                ? analytics.logScreenView(screenName: "app_daily_quiz_desc", screenClass: "app_QuizDetailsScreen", parameters: {
                                    "language": quizModelData.language,
                                    "title": quizModelData.quizTitle,
                                    "id": quizModelData.id,
                                  })
                                : analytics.logEvent(name: "app_checking_quiz_result", parameters: {
                                    "language": quizModelData.language,
                                    "title": quizModelData.quizTitle,
                                    "id": quizModelData.id,
                                  });
                            isAttempted
                                ? resultfunction(context: context, id: quizModelData.id, name: quizModelData.quizTitle)
                                : Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) =>  QuizDetailsScreenLib(
                                                    title: quizModelData.quizTitle,
                                                    id: quizModelData.id,
                                                    noQuestion: int.parse(quizModelData.noQues),
                                                  )
                                      
                                      // QuizDetailsScreen(
                                      //   language: quizModelData.language,
                                      //   title: quizModelData.quizTitle,
                                      //   id: quizModelData.id,
                                      //   descration: quizModelData.quizDesc,
                                      //   duration: quizModelData.quizDuration,
                                      //   isnegative: quizModelData.isNegative,
                                      //   noQuestion: int.parse(quizModelData.noQues),
                                      //   startdate: quizModelData.quizCreatedAt,
                                      //   shareLink: quizModelData.shareUrl?.link ?? "",
                                      //   shareText: quizModelData.shareUrl?.text ?? "",
                                      //   image: quizModelData.quizBanner,
                                      // ),
                                    ),
                                  );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: ColorResources.buttoncolor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  //'Continue'
                                  isAttempted ? Languages.result : Languages.continueText,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.notoSansDevanagari(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                                ), // <-- Text
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: ColorResources.textWhite.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _iconTextWidget(String text, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: GoogleFonts.notoSansDevanagari(fontSize: Fontsize().h5),
        )
      ],
    );
  }

  Widget progess({
    required BuildContext context,
    required double percent,
    required String center,
    required String footer,
  }) {
    return CircularPercentIndicator(
      radius: MediaQuery.of(context).size.width * 0.10,
      lineWidth: 8.0,
      animation: true,
      percent: percent,
      center: Text(
        center,
        style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.bold, fontSize: 10.0),
      ),
      footer: Text(
        footer,
        style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.bold, fontSize: 12.0),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: ColorResources.buttoncolor,
    );
  }

  Widget bottom({
    required BuildContext context,
    required Color backgroundcolor,
    required String center,
    required Color centertextcolor,
    required String footer,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.12,
          width: MediaQuery.of(context).size.width * 0.12,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: backgroundcolor, borderRadius: BorderRadius.circular(100)),
          child: Text(
            center,
            style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.bold, color: centertextcolor, fontSize: 12.0),
          ),
        ),
        Text(
          footer,
          style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack, fontSize: 12.0),
        )
      ],
    );
  }

  resultfunction({required BuildContext context, required String id, required String name}) {
    Preferences.onLoading(context);
    RemoteDataSourceImpl().getrResultById(id, null).then(
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
                                          footer: '${double.parse(response.data!.myScore!.number!)}/${response.data!.totalMarks!}',
                                          percent: (double.parse(response.data!.myScore!.percentage!)).abs(),
                                          radius: MediaQuery.of(context).size.width * 0.10,
                                        ),
                                        ProgressbarWidget(
                                          center: "${response.data!.accuracy!.number}%",
                                          footer: Preferences.appString.accuracy ?? 'Accuracy',
                                          percent: (double.parse(response.data!.accuracy!.percentage!)).abs(),
                                          radius: MediaQuery.of(context).size.width * 0.10,
                                        ),
                                        ProgressbarWidget(
                                          center: response.data!.toperScore!.number!,
                                          footer: Preferences.appString.topperScore ?? "Topper's Score",
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
                                  footer: 'Correct',
                                ),
                                RounderTextwidget(
                                  backgroundcolor: const Color(0XFFFB5259),
                                  center: response.data!.summary!.wrongAnswers.toString(),
                                  centertextcolor: ColorResources.textWhite,
                                  footer: 'Incorrect',
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
                                      data: response.data,
                                      name: name,
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
                              response.data!.isPublished! ? "View Detailed Analysis" : Languages.resultnotpublishyet,
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
