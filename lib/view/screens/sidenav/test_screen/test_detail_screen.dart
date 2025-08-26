import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sd_campus_app/features/cubit/quiz/quiz_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/models/Test_series/testseriesdetails.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/bottomnav/quiz/quiz_page.dart';
import 'package:sd_campus_app/view/screens/sidenav/test_screen/test_result.dart';
import 'package:sd_campus_app/view/screens/sidenav/test_screen/test_submit.dart';

class TestDetailsScreen extends StatefulWidget {
  final TestSeriesDetailsData data;
  const TestDetailsScreen({super.key, required this.data});

  @override
  State<TestDetailsScreen> createState() => _TestDetailsScreenState();
}

class _TestDetailsScreenState extends State<TestDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // print(widget.data.isAttempted!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          //Languages.myTestseries,
          widget.data.testTitle!,
          style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(color: ColorResources.gray.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "-ve",
                                    style: GoogleFonts.notoSansDevanagari(color: ColorResources.buttoncolor),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(Languages.negtiveMarketing),
                                ],
                              ),
                              Switch(
                                value: widget.data.isNegativeMarking!,
                                activeColor: ColorResources.buttoncolor,
                                onChanged: (value) {},
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.data.testTitle!,
                          style: GoogleFonts.notoSansDevanagari(fontSize: 20, fontWeight: FontWeight.bold, color: ColorResources.textblack),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(Languages.description, style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                            //'Lorem Ipsum is simply dummy text of the printing and'
                            //'typesetting industry. Lorem Ipsum has been the industry'
                            //'standard dummy text ever since the 1500s, when an'
                            //'unknown printer took a galley of type and scrambled'
                            //'it to make a type specimen book'
                            widget.data.instructions!,
                            style: GoogleFonts.notoSansDevanagari()),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorResources.borderColor.withValues(alpha: 0.3),
                          ),
                          child: ListTile(
                            title: Text(
                              Languages.questionpaper,
                              style: GoogleFonts.notoSansDevanagari(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: ColorResources.textblack,
                              ),
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                flutterToast("Downloading..");
                                download(widget.data.questionPaper!.fileLoc, widget.data.questionPaper!.fileName);
                                // launchUrl(
                                //     Uri.parse(
                                //         widget.data.questionPaper!.fileLoc!),
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
                        ),
                        // widget.data.isAttempted! && (widget.data.testMode == "offline" || widget.data.testMode == "both") && widget.data.answerSheet != null
                        //     ? Container(
                        //         margin: const EdgeInsets.symmetric(vertical: 5),
                        //         decoration: BoxDecoration(
                        //           color: const ColorResources.borderColor.withValues(alpha:0.3),
                        //           borderRadius: BorderRadius.circular(10),
                        //         ),
                        //         child: ListTile(
                        //           title: Text(
                        //             Languages.youranswersheet,
                        //             style: GoogleFonts.notoSansDevanagari(
                        //               fontWeight: FontWeight.w500,
                        //               fontSize: 20,
                        //               color: ColorResources.textblack,
                        //             ),
                        //           ),
                        //           trailing: GestureDetector(
                        //             onTap: () {
                        //               flutterToast("downloading..");
                        //               download(widget.data.answerSheet!.fileLoc, widget.data.answerSheet!.fileName);
                        //               // launchUrl(
                        //               //     Uri.parse(widget.data.attempted!
                        //               //         .answerSheet!.fileLoc!),
                        //               //     mode: LaunchMode.externalApplication);
                        //             },
                        //             child: CircleAvatar(
                        //               radius: 20.0,
                        //               backgroundColor: ColorResources.buttoncolor,
                        //               child: Icon(
                        //                 Icons.file_download_outlined,
                        //                 size: 25,
                        //                 color: ColorResources.textWhite,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     : Container(),
                        // : Container(),
                        // widget.data.isAttempted! && (widget.data.testMode == "offline" || widget.data.testMode == "both") && widget.data.checkedAnswerSheet != null && widget.data.checkedAnswerSheet!.fileLoc!.isNotEmpty
                        //     ? Container(
                        //         margin: const EdgeInsets.symmetric(vertical: 10),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10),
                        //           color: const ColorResources.borderColor.withValues(alpha:0.3),
                        //         ),
                        //         child: ListTile(
                        //           title: Text(
                        //             Languages.checkedAnswer,
                        //             style: GoogleFonts.notoSansDevanagari(
                        //               fontWeight: FontWeight.w500,
                        //               fontSize: 20,
                        //               color: ColorResources.textblack,
                        //             ),
                        //           ),
                        //           trailing: GestureDetector(
                        //             onTap: () {
                        //               flutterToast("downloading..");
                        //               download(widget.data.checkedAnswerSheet!.fileLoc, widget.data.checkedAnswerSheet!.fileName);
                        //               // launchUrl(
                        //               //     Uri.parse(widget.data.attempted!
                        //               //         .answerSheet!.fileLoc!),
                        //               //     mode: LaunchMode.externalApplication);
                        //             },
                        //             child: CircleAvatar(
                        //               radius: 20.0,
                        //               backgroundColor: ColorResources.buttoncolor,
                        //               child: Icon(
                        //                 Icons.file_download_outlined,
                        //                 size: 25,
                        //                 color: ColorResources.textWhite,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     : Container(),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: ColorResources.borderColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              Languages.oMRSheet,
                              // widget.data.questionsPaperType=='objective'?
                              style: GoogleFonts.notoSansDevanagari(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: ColorResources.textblack,
                              ),
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                flutterToast("Downloading..");
                                download(widget.data.answerTemplate!.fileLoc, widget.data.answerTemplate!.fileName);
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
                        ),
                        //Don't delete this box it give bottom padding
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.95,
                    child:
                        //  widget.data.questionsPaperType != "objective"
                        //     ?
                        Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              if (widget.data.questionsPaperType != "objective") {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => TestSubmitScreen(
                                    questionPaper: widget.data.questionPaper!.fileLoc!,
                                    name: widget.data.testTitle!,
                                    id: widget.data.testId!,
                                    examtype: widget.data.questionsPaperType!,
                                    time: Duration(
                                      minutes: int.parse(widget.data.duration!),
                                    ).inSeconds,
                                  ),
                                ));
                              } else {
                                objectButtons(
                                  context: context,
                                  id: widget.data.testId!,
                                  isOfflineAtt: (widget.data.testMode == "offline" || widget.data.testMode == "both"),
                                  isOnlineAtt: (widget.data.testMode != "offline" || widget.data.testMode == "both"),
                                  isAttempted: widget.data.isAttempted!,
                                  questionPaper: widget.data.questionPaper!.fileLoc!,
                                  name: widget.data.testTitle!,
                                  examtype: widget.data.questionsPaperType!,
                                  time: Duration(
                                    minutes: int.parse(widget.data.duration!),
                                  ).inSeconds,
                                  noQuestion: widget.data.noOfQuestions!,
                                  title: widget.data.testTitle!,
                                );
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                color: ColorResources.buttoncolor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                Languages.startTest,
                                //widget.data.isAttempted! ? Languages.Startagain : Languages.StartTest,
                                style: GoogleFonts.notoSansDevanagari(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        widget.data.isAttempted!
                            ? TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => TestResultScreen(
                                        title: widget.data.testTitle!,
                                        id: widget.data.testSeriesId!,
                                        isObjective: widget.data.questionsPaperType == "objective" ? true : false,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  Languages.viewResult,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.notoSansDevanagari(
                                    decoration: TextDecoration.underline,
                                    color: ColorResources.buttoncolor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                    // : Row(
                    //     children: [
                    //       ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(12), // <-- Radius
                    //             ),
                    //             backgroundColor: ColorResources.buttoncolor),
                    //         onPressed: () {
                    //           Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //             builder: (context) => TestSubmitScreen(
                    //               questionPaper: widget.data.questionPaper!.fileLoc!,
                    //               name: widget.data.testTitle!,
                    //               id: widget.data.testId!,
                    //               examtype: widget.data.questionsPaperType!,
                    //               time: Duration(
                    //                 minutes: int.parse(widget.data.duration!),
                    //               ).inSeconds,
                    //             ),
                    //           ));
                    //         },
                    //         child: Padding(
                    //           padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //           child: Text(
                    //             widget.data.isAttempted! ? Languages.Startagain : Languages.StartTest,
                    //             style: GoogleFonts.notoSansDevanagari(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    //           ),
                    //         ),
                    //       ),
                    //       widget.data.questionsPaperType == "objective" ? const Spacer() : Container(),
                    //       widget.data.questionsPaperType == "objective" ? Text(Languages.or) : Container(),
                    //       widget.data.questionsPaperType == "objective" ? const Spacer() : Container(),
                    //       widget.data.questionsPaperType == "objective"
                    //           ? widget.data.isAttempted! && (widget.data.testMode != 'offline' || widget.data.testMode == "both")
                    //               ? SizedBox(
                    //                   child: ElevatedButton(
                    //                     onPressed: () {
                    //                       resultfunction(context: context, id: widget.data.testId!);
                    //                     },
                    //                     style: ElevatedButton.styleFrom(
                    //                         shape: RoundedRectangleBorder(
                    //                           borderRadius: BorderRadius.circular(12), // <-- Radius
                    //                         ),
                    //                         backgroundColor: ColorResources.buttoncolor),
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //                       child: Text(
                    //                         "Check Result",
                    //                         style: GoogleFonts.notoSansDevanagari(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 )
                    //               : GestureDetector(
                    //                   onTap: () {
                    //                     // print(widget.data.testId!);
                    //                     Preferences.onLoading(context);
                    //                     RemoteDataSourceImpl().getQuestionsById(widget.data.testId!).then((value) {
                    //                       Preferences.hideDialog(context);
                    //                       if (value.status!) {
                    //                         context.read<QuizCubit>().questionNumber = 1;
                    //                         context.read<QuizCubit>().answer_arr.clear();
                    //                         context.read<QuizCubit>().init(widget.data.noOfQuestions!);
                    //                         Navigator.of(context).push(
                    //                           MaterialPageRoute(
                    //                             builder: (context) => QuizScreen(
                    //                               title: widget.data.testTitle!,
                    //                               listofquestionsdata: value.data,
                    //                               noQuestion: widget.data.noOfQuestions!,
                    //                               id: widget.data.testId!,
                    //                               language: "eng",
                    //                               time: Duration(
                    //                                 minutes: int.parse(widget.data.duration!),
                    //                               ).inSeconds,
                    //                             ),
                    //                           ),
                    //                         );
                    //                       } else {
                    //                         flutterToast(value.msg!);
                    //                       }
                    //                     });
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => BlocProvider(
                    //       create: (context) => QuizCubit()
                    //         ..init(widget.data.noOfQuestions!),
                    //       child: LiveTestScreen(
                    //         noofquestion:
                    //             widget.data.noOfQuestions!,
                    //         questionPaper: widget
                    //             .data.questionPaper!.fileLoc!,
                    //         id: widget.data.sId!,
                    //         testname: widget.data.testTitle!,
                    //         examtype:
                    //             widget.data.questionPaperType!,
                    //         time: Duration(
                    //           minutes: int.parse(
                    //               widget.data.duration!),
                    //         ).inSeconds,
                    //       ),
                    //     ),
                    //   ),
                    // );
                    //                   },
                    //                   child: SizedBox(
                    //                     child: Container(
                    //                       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    //                       decoration: BoxDecoration(
                    //                         color: ColorResources.buttoncolor,
                    //                         borderRadius: BorderRadius.circular(10),
                    //                       ),
                    //                       alignment: Alignment.center,
                    //                       child: Text(
                    //                         Languages.Take_Live_Test,
                    //                         style: GoogleFonts.notoSansDevanagari(
                    //                           fontSize: 18,
                    //                           color: Colors.white,
                    //                           fontWeight: FontWeight.w500,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 )
                    //           : Container(),
                    //     ],
                    //   ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  download(url, name) async {
    bool hasPermission = await Preferences.checkStoragePermission();
    if (!hasPermission) return;
    var dir = await getApplicationDocumentsDirectory();
    // print(dir.path);
    // downloads the file
    Dio dio = Dio();
    await dio.download(url, "${dir.path}/${name!}.${url.split('.').last}");
    OpenFilex.open("${dir.path}/${name!}.${url.split('.').last}", type: 'application/pdf');
  }

  // Future<bool> _requestWritePermission() async {
  //   await Permission.storage.request();
  //   return await Permission.storage.request().isGranted;
  // }

  objectButtons({
    required BuildContext context,
    required String id,
    required bool isOnlineAtt,
    required bool isOfflineAtt,
    required bool isAttempted,
    required int noQuestion,
    required String title,
    required int time,
    required String examtype,
    required String name,
    required String questionPaper,
  }) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        //backgroundColor: Colors.white,
        clipBehavior: Clip.hardEdge,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, safeSetState) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => TestSubmitScreen(
                      questionPaper: questionPaper,
                      name: name,
                      id: id,
                      examtype: examtype,
                      time: time,
                    ),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    isOfflineAtt && isAttempted ? Languages.reAttemptOMRTest : Languages.startOMRTest,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textblack,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  Preferences.onLoading(context);
                  RemoteDataSourceImpl().getQuestionsById(id).then((value) {
                    Preferences.hideDialog(context);
                    if (value.status!) {
                      context.read<QuizCubit>().questionNumber = 1;
                      context.read<QuizCubit>().answerarr.clear();
                      context.read<QuizCubit>().init(noQuestion);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(title: title, listofquestionsdata: value.data, noQuestion: noQuestion, id: id, language: "eng", time: time),
                        ),
                      );
                    } else {
                      flutterToast(value.msg!);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    isOnlineAtt && isAttempted ? Languages.reAttemptLiveTest : Languages.takeLiveTest,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textblack,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ]);
          });
        });
  }
}
