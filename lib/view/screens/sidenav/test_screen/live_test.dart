import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
//import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:sd_campus_app/features/cubit/quiz/quiz_cubit.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/home.dart';
import 'package:sd_campus_app/view/screens/sidenav/test_screen/test_submit.dart';

class LiveTestScreen extends StatefulWidget {
  final String id;
  final String testname;
  final String examtype;
  final int noofquestion;
  final int time;
  final String questionPaper;
  const LiveTestScreen({
    super.key,
    required this.noofquestion,
    required this.questionPaper,
    required this.testname,
    required this.time,
    required this.examtype,
    required this.id,
  });

  @override
  State<LiveTestScreen> createState() => _LiveTestScreenState();
}

class _LiveTestScreenState extends State<LiveTestScreen> {
  final ScrollController _qnumbercontroller = ScrollController();
  String answer = "";
  final PdfViewerController pdfViewerController = PdfViewerController();

  @override
  void dispose() {
    pdfViewerController.dispose();
    super.dispose();
  }

  Future<bool> exitConfirm() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
              Preferences.appString.exitTestConfirmation ?? 'Do you want to exit ?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: ColorResources.textblack),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorResources.gray,
                  shape: const StadiumBorder(),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorResources.buttoncolor,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  // BlocProvider.of<QuizCubit>(context)
                  //     .submitQuizobjective(testid: widget.id);
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: ColorResources.textWhite,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitConfirm,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.textWhite,
          iconTheme: IconThemeData(color: ColorResources.textblack),
          title: Text(
            widget.testname,
            style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorResources.gray.withValues(alpha: 0.5),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Text(
                                        Languages.objectivetype,
                                        style: GoogleFonts.notoSansDevanagari(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: ColorResources.textblack,
                                        ),
                                      ),
                                      const Spacer(),
                                      ExamTimer(
                                        timeinsec: widget.time,
                                        style: GoogleFonts.notoSansDevanagari(
                                          color: ColorResources.buttoncolor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorResources.buttoncolor.withValues(alpha: 0.1),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: ListView.builder(
                                controller: _qnumbercontroller,
                                itemCount: widget.noofquestion,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return numberofQuestion(index, BlocProvider.of<QuizCubit>(context, listen: true).questionNumber - 1);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: FutureBuilder<File>(
                        future: DefaultCacheManager().getSingleFile(widget.questionPaper),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? PdfViewer.openFile(
                                  snapshot.data!.path,
                                  viewerController: pdfViewerController,
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                );
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      Languages.chooseAnswer,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.60,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 2.0,
                          crossAxisCount: 2,
                        ),
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return BlocBuilder<QuizCubit, QuizState>(
                            builder: (context, state) {
                              if (state is PrevQuestionState) {
                                answer = state.answer;
                              } else if (state is NextQuestionState) {
                                answer = state.answer;
                              }
                              if (state is SubmitSucessState) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HomeScreen(index: 2),
                                ));
                              } else if (state is QuizLoading) {
                                Preferences.onLoading(context);
                              }

                              return GestureDetector(
                                onTap: () {
                                  answer = (index + 1).toString();
                                  context.read<QuizCubit>().selectedoption(answer);
                                  // print(answer);
                                },
                                child: options(
                                  index,
                                  answer.isEmpty ? 99 : int.parse(answer),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: BlocProvider.of<QuizCubit>(context, listen: true).questionNumber > 1 ? ColorResources.buttoncolor : ColorResources.gray,
                child: IconButton(
                  padding: const EdgeInsets.only(left: 5),
                  onPressed: () {
                    // print(BlocProvider.of<QuizCubit>(context, listen: false)
                    // .questionNumber);
                    if (BlocProvider.of<QuizCubit>(context, listen: false).questionNumber > 1) {
                      context.read<QuizCubit>().prevquestion();
                      final contentSize = _qnumbercontroller.position.viewportDimension + _qnumbercontroller.position.maxScrollExtent;
                      _qnumbercontroller.position.animateTo(contentSize * BlocProvider.of<QuizCubit>(context, listen: false).questionNumber / widget.noofquestion - _qnumbercontroller.position.viewportDimension, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
                    } else {
                      // print('cont go back');
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              BlocListener<QuizCubit, QuizState>(
                listener: (context, state) {
                  // print(state);
                  // print(widget.id);
                  if (state is SubmitSucessState) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomeScreen(index: 2),
                    ));
                  } else if (state is QuizLoading) {
                    Preferences.onLoading(context);
                  }
                },
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResources.buttoncolor,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    context.read<QuizCubit>().submitQuizobjective(testid: widget.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                    child: Text(
                      Languages.submittest,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor: BlocProvider.of<QuizCubit>(context, listen: true).questionNumber < widget.noofquestion ? ColorResources.buttoncolor : ColorResources.gray,
                child: IconButton(
                  padding: const EdgeInsets.only(left: 5),
                  onPressed: () {
                    if (BlocProvider.of<QuizCubit>(context, listen: false).questionNumber < widget.noofquestion) {
                      context.read<QuizCubit>().nextquestion(answer);
                      answer = "";
                    }
                    // Get the full content height.
                    final contentSize = _qnumbercontroller.position.viewportDimension + _qnumbercontroller.position.maxScrollExtent;
                    _qnumbercontroller.position.animateTo(
                        // Estimate the target scroll position.
                        contentSize * BlocProvider.of<QuizCubit>(context, listen: false).questionNumber / widget.noofquestion - 96.0,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut);
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget options(option, answerselect) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: (option + 1) == answerselect ? Colors.green : ColorResources.textblack,
        ),
        color: (option + 1) == answerselect ? Colors.green.withValues(alpha: 0.5) : ColorResources.textWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        (option + 1).toString(),
        style: TextStyle(
          color: (option + 1) == answerselect ? Colors.green[900] : ColorResources.textblack,
        ),
      ),
    );
  }

  Widget numberofQuestion(index, currentquesionnum) {
    return Container(
      width: 40,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: index == currentquesionnum ? ColorResources.buttoncolor : Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        (index + 1).toString(),
        style: TextStyle(color: index == currentquesionnum ? ColorResources.textWhite : ColorResources.textblack),
      ),
    );
  }
}
