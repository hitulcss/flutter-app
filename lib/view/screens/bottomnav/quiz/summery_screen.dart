import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/leaderboard.dart';
import 'package:sd_campus_app/features/data/remote/models/resultmodel.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/prgress.dart';
import 'package:sd_campus_app/features/presentation/widgets/roundedtext.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/bottomnav/quiz/leaderboard.dart';
import 'package:sd_campus_app/view/screens/bottomnav/quiz/reportpage.dart';
import 'package:url_launcher/url_launcher.dart';

class SummaryScreen extends StatefulWidget {
  final ResultModelData? data;
  final String name;
  const SummaryScreen({super.key, required this.data, required this.name});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool isEnglish = true;
  @override
  void initState() {
    super.initState();
    analytics.logEvent(name: "app_quiz_data", parameters: {
      "data": jsonEncode(widget.data?.toJson())
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(
          color: ColorResources.textblack,
        ),
        elevation: 0,
        title: Text(
          'View Detailed Analysis',
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              safeSetState(() {
                if (isEnglish) {
                  isEnglish = false;
                } else {
                  isEnglish = true;
                }
              });
            },
            child: Container(
              height: 30,
              width: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: ColorResources.buttoncolor.withValues(alpha: 0.2),
              ),
              child: Text(
                isEnglish ? "A" : "अ",
                style: TextStyle(color: ColorResources.buttoncolor),
              ),
            ),
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.info_outline_rounded,
              color: ColorResources.buttoncolor,
              size: 30,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text(Languages.reportanIssue),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(Languages.askaDoubt),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReportScreen(id: widget.data!.quizId!, isreport: true),
                ));
              }
              if (value == 2) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReportScreen(id: widget.data!.quizId!, isreport: false),
                ));
              }
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints.expand(height: 50),
              color: ColorResources.textWhite,
              child: TabBar(
                physics: const NeverScrollableScrollPhysics(),
                indicatorColor: ColorResources.buttoncolor,
                labelColor: ColorResources.buttoncolor,
                unselectedLabelColor: ColorResources.textblack,
                tabs: [
                  Tab(text: Languages.summary),
                  Tab(text: Languages.difficulty),
                  const Tab(text: 'Leaderboard'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(physics: const NeverScrollableScrollPhysics(), children: [
                SingleChildScrollView(child: summery(context: context)),
                SingleChildScrollView(child: difficulty(context: context)),
                FutureBuilder<LeaderboardsModel>(
                    future: RemoteDataSourceImpl().getLeaderboards(id: widget.data!.quizId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return ErrorWidgetapp(image: SvgImages.error404, text: snapshot.error.toString());
                        } else {
                          return LeaderboardScreen(
                            title: widget.name,
                            data: snapshot.data!,
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget difficulty({required BuildContext context}) {
    return widget.data!.isPublished!
        ? Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: ColorResources.textWhite,
                  boxShadow: [
                    BoxShadow(
                      color: ColorResources.gray.withValues(alpha: 0.5),
                      offset: const Offset(-2, -5),
                      spreadRadius: 3,
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ProgressbarWidget(
                          center: widget.data!.difficulty!.easy!.number.toString(),
                          footer: Languages.easy,
                          percent: double.parse(widget.data!.difficulty!.easy!.percentage!),
                          radius: MediaQuery.of(context).size.width * 0.10,
                        ),
                        ProgressbarWidget(
                          center: widget.data!.difficulty!.medium!.number!,
                          footer: Languages.medium,
                          percent: double.parse(widget.data!.difficulty!.medium!.percentage!),
                          radius: MediaQuery.of(context).size.width * 0.10,
                        ),
                        ProgressbarWidget(
                          center: widget.data!.difficulty!.hard!.number!,
                          footer: Languages.hard,
                          percent: double.parse(widget.data!.difficulty!.hard!.percentage!),
                          radius: MediaQuery.of(context).size.width * 0.10,
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RounderTextwidget(
                          backgroundcolor: const Color(0XFF37AEE2),
                          center: widget.data!.summary!.noOfQues.toString(),
                          centertextcolor: ColorResources.textWhite,
                          footer: Languages.total,
                        ),
                        RounderTextwidget(
                          backgroundcolor: const Color(0XFFFFB800),
                          center: widget.data!.summary!.attempted.toString(),
                          centertextcolor: ColorResources.textWhite,
                          footer: Languages.attempted,
                        ),
                        RounderTextwidget(
                          backgroundcolor: const Color(0XFF57D163),
                          center: widget.data!.summary!.correctAns.toString(),
                          centertextcolor: ColorResources.textWhite,
                          footer: Languages.correctness,
                        ),
                        RounderTextwidget(
                          backgroundcolor: const Color(0XFFFB5259),
                          center: widget.data!.summary!.wrongAnswers.toString(),
                          centertextcolor: ColorResources.textWhite,
                          footer: 'Incorrect',
                        ),
                        RounderTextwidget(
                          backgroundcolor: const Color(0XFFBBE3FF),
                          center: widget.data!.summary!.skipped.toString(),
                          centertextcolor: ColorResources.textblack,
                          footer: Languages.skipped,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  Languages.questionsSummary,
                  style: GoogleFonts.notoSansDevanagari(
                    //fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.data!.response!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return questionwidget(index: index, requestiondata: widget.data!.response![index]);
                },
              ),
            ],
          )
        : Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RounderTextwidget(
                    backgroundcolor: const Color(0XFF37AEE2),
                    center: widget.data!.summary!.noOfQues.toString(),
                    centertextcolor: ColorResources.textWhite,
                    footer: Languages.total,
                  ),
                  RounderTextwidget(
                    backgroundcolor: const Color(0XFFFFB800),
                    center: widget.data!.summary!.attempted.toString(),
                    centertextcolor: ColorResources.textWhite,
                    footer: Languages.attempted,
                  ),
                  RounderTextwidget(
                    backgroundcolor: const Color(0XFFBBE3FF),
                    center: widget.data!.summary!.skipped.toString(),
                    centertextcolor: ColorResources.textblack,
                    footer: Languages.skipped,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  )
                ]),
                child: EmptyWidget(image: SvgImages.emptyresultcalculation, text: "Waiting for the result....\nYour result yet to publish."),
              )
            ],
          );
  }

  Widget summery({required BuildContext context}) {
    return widget.data!.isPublished!
        ? Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: ColorResources.textWhite,
                  boxShadow: [
                    BoxShadow(
                      color: ColorResources.gray.withValues(alpha: 0.5),
                      offset: const Offset(-2, -5),
                      spreadRadius: 3,
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: Column(children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: PieChart(
                      dataMap: {
                        "Correct": (widget.data!.summary!.correctAns! / widget.data!.summary!.noOfQues!) * 100,
                        "Incorrect": (widget.data!.summary!.wrongAnswers! / widget.data!.summary!.noOfQues!) * 100,
                        "Skipped": (widget.data!.summary!.skipped! / widget.data!.summary!.noOfQues!) * 100,
                      },
                      colorList: const [
                        Color(0XFF57D163),
                        Color(0XFFFB5259),
                        Color(0XFFBBE3FF),
                      ],
                      chartType: ChartType.ring,
                      legendOptions: const LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: false,
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                        decimalPlaces: 1,
                      ),
                      animationDuration: const Duration(seconds: 2),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RounderTextwidget(
                        backgroundcolor: const Color(0XFF37AEE2),
                        center: widget.data!.summary!.noOfQues.toString(),
                        centertextcolor: ColorResources.textWhite,
                        footer: Languages.total,
                      ),
                      RounderTextwidget(
                        backgroundcolor: const Color(0XFFFFB800),
                        center: widget.data!.summary!.attempted.toString(),
                        centertextcolor: ColorResources.textWhite,
                        footer: Languages.attempted,
                      ),
                      RounderTextwidget(
                        backgroundcolor: const Color(0XFF57D163),
                        center: widget.data!.summary!.correctAns.toString(),
                        centertextcolor: ColorResources.textWhite,
                        footer: Languages.correctness,
                      ),
                      RounderTextwidget(
                        backgroundcolor: const Color(0XFFFB5259),
                        center: widget.data!.summary!.wrongAnswers.toString(),
                        centertextcolor: ColorResources.textWhite,
                        footer: Languages.incorrect,
                      ),
                      RounderTextwidget(
                        backgroundcolor: const Color(0XFFBBE3FF),
                        center: widget.data!.summary!.skipped.toString(),
                        centertextcolor: ColorResources.textblack,
                        footer: Languages.skipped,
                      ),
                    ],
                  ),
                ]),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 0, left: 10, right: 10),
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
                            Languages.quizPerformance,
                            style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.bold, color: ColorResources.textblack, fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProgressbarWidget(
                            center: widget.data!.myScore!.number!,
                            footer: '${double.parse(widget.data!.myScore!.number!)}/${widget.data!.totalMarks!.split('.')[0]}',
                            percent: (double.parse(widget.data!.myScore!.percentage!)).abs(),
                            radius: MediaQuery.of(context).size.width * 0.10,
                          ),
                          ProgressbarWidget(
                            center: "${widget.data!.accuracy!.number}%",
                            footer: Preferences.appString.accuracy ?? Languages.accuracy,
                            percent: (double.parse(widget.data!.accuracy!.percentage!)).abs(),
                            radius: MediaQuery.of(context).size.width * 0.10,
                          ),
                          ProgressbarWidget(
                            center: widget.data!.toperScore!.number!,
                            footer: Preferences.appString.topperScore ?? Languages.topperScore,
                            percent: (double.parse(widget.data!.toperScore!.percentage!)).abs(),
                            radius: MediaQuery.of(context).size.width * 0.10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  Languages.questionsSummary,
                  style: GoogleFonts.notoSansDevanagari(
                    //fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.data!.response!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return questionwidget(index: index, requestiondata: widget.data!.response![index]);
                },
              ),
            ],
          )
        : Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RounderTextwidget(
                    backgroundcolor: const Color(0XFF37AEE2),
                    center: widget.data!.summary!.noOfQues.toString(),
                    centertextcolor: ColorResources.textWhite,
                    footer: Languages.total,
                  ),
                  RounderTextwidget(
                    backgroundcolor: const Color(0XFFFFB800),
                    center: widget.data!.summary!.attempted.toString(),
                    centertextcolor: ColorResources.textWhite,
                    footer: Languages.attempted,
                  ),
                  RounderTextwidget(
                    backgroundcolor: const Color(0XFFBBE3FF),
                    center: widget.data!.summary!.skipped.toString(),
                    centertextcolor: ColorResources.textblack,
                    footer: Languages.skipped,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  )
                ]),
                child: EmptyWidget(image: SvgImages.emptyresultcalculation, text: "Waiting for the result....\nYour result yet to publish."),
              )
            ],
          );
  }

  Widget questionwidget({required int index, required QuestionResponse requestiondata}) {
    String youranswer = optionabcd(int.parse(requestiondata.myAnswer?.isEmpty ?? true ? "5" : requestiondata.myAnswer!));
    String rightanswers = optionabcd(int.parse((requestiondata.correctOption?.trim().isEmpty ?? true) ? "5" : requestiondata.correctOption?.trim() ?? "5"));
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: ColorResources.textWhite,
        boxShadow: [
          BoxShadow(
            color: ColorResources.gray.withValues(alpha: 0.3),
            offset: const Offset(3, -1),
            spreadRadius: 3,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(children: [
        FractionallySizedBox(
          widthFactor: 0.9,
          child: Html(
            data: "${(index + 1).toString()}. ${isEnglish ? requestiondata.questionTitle?.e : requestiondata.questionTitle?.h}",
            onAnchorTap: (url, attributes, element) {
              Uri openurl = Uri.parse(url!);
              launchUrl(
                openurl,
              );
            },
            // textAlign: TextAlign.justify,
            // style: TextStyle(
            //   fontSize: 16,
            //   color: ColorResources.textblack,
            //   fontWeight: FontWeight.w500,
            // ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: FractionallySizedBox(
            widthFactor: 0.95,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                String optionstring = "";
                switch (index) {
                  case 0:
                    optionstring = isEnglish ? requestiondata.option1?.e ?? "" : requestiondata.option1?.h ?? "";
                    break;
                  case 1:
                    optionstring = isEnglish ? requestiondata.option2?.e ?? "" : requestiondata.option2?.h ?? "";
                    break;
                  case 2:
                    optionstring = isEnglish ? requestiondata.option3?.e ?? "" : requestiondata.option3?.h ?? "";
                    break;
                  case 3:
                    optionstring = isEnglish ? requestiondata.option4?.e ?? "" : requestiondata.option4?.h ?? "";
                    break;
                  default:
                  //optionstring = "";
                }
                return options(answerselect: int.parse(requestiondata.myAnswer?.isEmpty ?? true ? "5" : requestiondata.myAnswer ?? "5"), index: index, context: context, option: optionstring, rightanswer: requestiondata.correctOption?.trim().isEmpty ?? true ? 5 : int.parse(requestiondata.correctOption ?? "5"));
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: ExpansionTile(
            leading: Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                  Text(
                    "Your Answer : $youranswer",
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 10,
                      color: ColorResources.textblack,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.note_alt_outlined,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Explanation",
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 10,
                          color: ColorResources.textblack,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ],
              ),
            ),
            title: Column(
              children: [
                const Icon(
                  Icons.verified_outlined,
                  color: Colors.green,
                ),
                Text(
                  "Correct Answer: $rightanswers",
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 10,
                    color: ColorResources.textblack,
                  ),
                ),
              ],
            ),
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                  ),
                ]),
                child: Column(
                  children: [
                    Text(
                      "Explanation:- ",
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 14,
                        color: ColorResources.buttoncolor,
                      ),
                    ),
                    Html(
                      data: Languages.isEnglish ? requestiondata.answer!.e : requestiondata.answer!.h,
                      onAnchorTap: (url, attributes, element) {
                        Uri openurl = Uri.parse(url!);
                        launchUrl(
                          openurl,
                        );
                      },
                      // style: GoogleFonts.notoSansDevanagari(
                      //   fontSize: 14,
                      //   color: ColorResources.textblack,
                      // ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  String optionabcd(int answerselect) {
    String letter = "";
    switch (answerselect) {
      case 1:
        letter = "A";
        break;
      case 2:
        letter = "B";
        break;
      case 3:
        letter = "C";
        break;
      case 4:
        letter = "D";
        break;
      default:
    }
    return letter;
  }

  Widget options({
    required String option,
    required int index,
    required int answerselect,
    required BuildContext context,
    required int rightanswer,
  }) {
    // bool answerright = answerselect == rightanswer ? true : false;
    // print(option);
    // print(index);
    // print(answerselect);
    // print(rightanswer);
    String answer = "";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: (index + 1) == rightanswer
                ? Colors.greenAccent.withValues(alpha: 0.1)
                : (index + 1) == answerselect
                    ? ColorResources.buttoncolor.withValues(alpha: 0.1)
                    : ColorResources.gray,
            offset: Offset.fromDirection(0.9, 2.0),
            blurRadius: 5.0,
          )
        ],
        border: Border.all(
          color: (index + 1) == rightanswer
              ? Colors.green[900]!
              : (index + 1) == answerselect
                  ? ColorResources.buttoncolor
                  : Colors.transparent,
        ),
        color: (index + 1) == rightanswer
            ? Colors.green.withValues(alpha: 0.3)
            : (index + 1) == answerselect
                ? ColorResources.buttoncolor.withValues(alpha: 0.2)
                : ColorResources.textWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Radio(
              fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return (index + 1) == rightanswer ? Colors.green[700]! : ColorResources.buttoncolor;
                }
                return Colors.black;
              }),
              value: (index + 1).toString(),
              groupValue: (index + 1) == answerselect || (index + 1) == rightanswer ? (index + 1).toString() : answer,
              onChanged: (value) {}),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.70,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                option,
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 14,
                  color: (index + 1) == rightanswer
                      ? Colors.green[900]
                      : (index + 1) == answerselect
                          ? ColorResources.buttoncolor
                          : ColorResources.textblack,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
