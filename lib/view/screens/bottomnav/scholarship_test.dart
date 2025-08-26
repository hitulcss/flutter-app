import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/date_formate.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/library/quiz/quiz_detail_screen.dart';
import 'package:share_plus/share_plus.dart';

class ScholarshipTestScreen extends StatefulWidget {
  final String id;
  const ScholarshipTestScreen({super.key, required this.id});

  @override
  State<ScholarshipTestScreen> createState() => _ScholarshipTestScreenState();
}

class _ScholarshipTestScreenState extends State<ScholarshipTestScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: FutureBuilder(
          future: RemoteDataSourceImpl().getTestRegistByidRequest(id: widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: ColorResources.textWhite,
                    iconTheme: IconThemeData(color: ColorResources.textblack),
                    title: Text(
                      snapshot.data!.data!.title!,
                      style: GoogleFonts.notoSansDevanagari(
                        color: ColorResources.textblack,
                      ),
                    ),
                    actions: [
                      if (snapshot.data!.data?.shareUrl?.link != null && (snapshot.data?.data?.shareUrl?.link?.isNotEmpty ?? false))
                        IconButton(
                            onPressed: () {
                              try {
                                Share.share("${snapshot.data?.data?.shareUrl?.text ?? ""}\n${snapshot.data?.data?.shareUrl?.link ?? ""}");
                              } catch (e) {
                                // print(e);
                              }
                            },
                            icon: const Icon(
                              Icons.share,
                            ))
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            // height: MediaQuery.sizeOf(context).height * 0.6,
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CachedNetworkImage(
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                      imageUrl: SvgImages.testregbackground,
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    )
                                  ],
                                ),
                                Positioned(
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.sizeOf(context).width * 0.91,
                                        minWidth: MediaQuery.sizeOf(context).width * 0.91,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: ColorResources.buttoncolor,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            Preferences.appString.crackYourDreamExamWith ?? 'Crack Your Dream Exam With',
                                            style: TextStyle(
                                              color: ColorResources.buttoncolor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '*  ${Preferences.appString.leaderboardWillBePublishedAfter ?? "Leaderboard will be published after"} ${DateFormat("dd MMM yyyy hh:mm a").format(DateFormat("dd-MM-yyyy HH:mm:ss").parse(snapshot.data!.data!.resultDeclaration!))}',
                                            style: TextStyle(
                                              color: ColorResources.textblack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      snapshot.data!.data!.title!,
                                      style: TextStyle(
                                        color: ColorResources.textblack,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 150,
                                    left: 10,
                                    child: Stack(
                                      fit: StackFit.loose,
                                      children: [
                                        SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) => const Center(
                                                child: CircularProgressIndicator(),
                                              ),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                              imageUrl: SvgImages.calenderimage,
                                            )),
                                        Positioned(
                                          top: 50,
                                          left: 15,
                                          child: Text(
                                            "${DateFormat('dd MMM yyyy').format(DateFormat('dd-MM-yyyy').parse(snapshot.data!.data!.startingAt!.split(" ").first))} \n${DateFormat.jms().format(DateFormat('dd-MM-yyyy HH:mm:ss').parse(snapshot.data!.data!.startingAt!))}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: ColorResources.textblack,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: ColorResources.textWhite,
                              border: Border.all(
                                color: ColorResources.buttoncolor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${Preferences.appString.testDuration ?? "Test Duration"} :- ',
                                        style: TextStyle(
                                          color: ColorResources.textblack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                      TextSpan(
                                        text: AppDateFormate.formatDuration(Duration(minutes: int.parse(snapshot.data!.data!.duration!))),
                                        style: TextStyle(
                                          color: ColorResources.textBlackSec,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${Preferences.appString.test ?? "Test"} ${Preferences.appString.startAt ?? "Starts At"} :- ',
                                        style: TextStyle(
                                          color: ColorResources.textblack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: DateFormat("dd MMM yyyy hh:mm a").format(DateFormat("dd-MM-yyyy HH:mm:ss").parse(snapshot.data!.data!.startingAt!)),
                                        style: TextStyle(
                                          color: ColorResources.textBlackSec,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${Preferences.appString.resultDeclaration ?? "Result Declaration"} :- ',
                                        style: TextStyle(
                                          color: ColorResources.textblack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: DateFormat("dd MMM yyyy hh:mm a").format(DateFormat("dd-MM-yyyy HH:mm:ss").parse(snapshot.data!.data!.resultDeclaration!)),
                                        style: TextStyle(
                                          color: ColorResources.textBlackSec,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: ColorResources.textWhite,
                              border: Border.all(
                                color: ColorResources.buttoncolor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    Preferences.appString.testGuidelines ?? 'Test Guidelines',
                                    style: TextStyle(
                                      color: ColorResources.buttoncolor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: ColorResources.buttoncolor,
                                ),
                                ListView.separated(
                                  itemCount: Preferences.remotescholarshipguidance.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) => Divider(
                                    color: ColorResources.buttoncolor,
                                  ),
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 60,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: ColorResources.buttoncolor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            (index + 1).toString().padLeft(2, "0"),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Preferences.remotescholarshipguidance[index].heading ?? 'Only one attempt allowed',
                                                style: TextStyle(
                                                  color: ColorResources.textblack,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                Preferences.remotescholarshipguidance[index].description ?? 'Test Once started can’t be  stopped| restarted.',
                                                style: TextStyle(
                                                  color: ColorResources.textBlackSec,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
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
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: BottomAppBar(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: snapshot.data!.data!.isRegister!
                                      ? DateFormat("dd-MM-yyyy HH:mm:ss").parse(snapshot.data!.data!.startingAt!).difference(DateTime.now()).inSeconds < 0
                                          ? ColorResources.buttoncolor
                                          : ColorResources.gray
                                      : DateFormat("dd-MM-yyyy HH:mm:ss").parse(snapshot.data!.data!.resultDeclaration!).difference(DateTime.now()).inSeconds > 0
                                          ? ColorResources.buttoncolor
                                          : ColorResources.gray),
                              onPressed: () {
                                if (snapshot.data!.data!.isRegister!) {
                                  analytics.logEvent(name: "app_test_trying_to_attempt");
                                  if (DateFormat("dd-MM-yyyy").parse(snapshot.data!.data!.startingAt!).difference(DateTime.now()).inSeconds <= 0) {
                                    Preferences.onLoading(context);
                                    RemoteDataSourceImpl().getQuizbyid(id: snapshot.data!.data!.quizId!).then((value) {
                                      Preferences.hideDialog(context);
                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (context) => QuizDetailsScreenLib(
                                                  title: value.data?.quizTitle ?? "",
                                                  id: value.data?.id ?? "",
                                                  noQuestion: int.parse(value.data?.noQues ?? "0"),
                                                )
                                            //  QuizDetailsScreen(
                                            //   language: value.data!.language!,
                                            //   title: value.data!.quizTitle!,
                                            //   id: value.data!.id!,
                                            //   descration: value.data!.quizDesc!,
                                            //   duration: value.data!.quizDuration!,
                                            //   isnegative: value.data!.isNegative!,
                                            //   noQuestion: int.parse(value.data!.noQues!),
                                            //   startdate: value.data!.quizCreatedAt!,
                                            //   shareLink: value.data?.shareUrl?.link ?? "",
                                            //   shareText: value.data?.shareUrl?.text ?? "",
                                            //   image: value.data?.quizBanner ?? "",
                                            // ),
                                            ),
                                      );
                                    });
                                  } else {
                                    flutterToast("The test Start at ${snapshot.data!.data!.startingAt}");
                                  }
                                } else {
                                  analytics.logEvent(name: "app_test_trying_to_reg");
                                  if (DateFormat("dd-MM-yyyy").parse(snapshot.data!.data!.startingAt!).difference(DateTime.now()).inSeconds <= 0) {
                                    flutterToast("Test registration completed at ${snapshot.data!.data!.startingAt}");
                                  } else {
                                    Preferences.onLoading(context);
                                    RemoteDataSourceImpl().scholarshipTestRegesterRequest(id: snapshot.data!.data!.id!).then((value) {
                                      Preferences.hideDialog(context);
                                      safeSetState(() {});
                                    });
                                  }
                                }
                              },
                              child: Text(
                                snapshot.data!.data!.isRegister!
                                    ? DateFormat("dd-MM-yyyy HH:mm:ss").parse(snapshot.data!.data!.startingAt!).difference(DateTime.now()).inSeconds < 0
                                        ? "Attempt Test"
                                        : " Already Register "
                                    : DateFormat("dd-MM-yyyy HH:mm:ss").parse(snapshot.data!.data!.resultDeclaration!).difference(DateTime.now()).inSeconds > 0
                                        ? 'Register For Free'
                                        : 'Registration Closed',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Scaffold(
                  body: Center(
                    child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"),
                  ),
                );
              }
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }

  List<Widget> testGuidelines() {
    return [];
  }
}
