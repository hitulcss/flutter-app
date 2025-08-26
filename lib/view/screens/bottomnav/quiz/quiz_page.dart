import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/cubit/quiz/quiz_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/roundedtext.dart';
import 'package:sd_campus_app/models/library/get_quiz_question_library.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:html/parser.dart' show parse;
import 'package:sd_campus_app/view/screens/bottomnav/quiz/summery_screen.dart';
import 'package:sd_campus_app/view/screens/sidenav/test_screen/test_submit.dart';
import 'package:url_launcher/url_launcher.dart';

class QuizScreen extends StatefulWidget {
  final String id;
  final String language;
  final int noQuestion;
  final String title;
  final int time;
  final List<GetQuizQuestionLibraryData>? listofquestionsdata;
  const QuizScreen({
    super.key,
    required this.title,
    required this.listofquestionsdata,
    required this.noQuestion,
    required this.id,
    required this.language,
    required this.time,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with WidgetsBindingObserver {
  final ScrollController _qnumbercontroller = ScrollController();
  String answer = "";

  bool isenglish = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //BlocProvider.of<QuizCubit>(context).submitQuizobjective(testid: widget.id);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        context.read<QuizCubit>().submitResumeQuizobjective(
              testid: widget.id,
            );
        //detachedCallBack;
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.hidden:
        break;
    }
    // print('''
// =============================================================
//                $state
// =============================================================
// ''');
  }

  getoptions(int index) {
    switch (index) {
      case 0:
        return isenglish ? widget.listofquestionsdata![BlocProvider.of<QuizCubit>(context, listen: true).questionNumber - 1].option1!.e : widget.listofquestionsdata![BlocProvider.of<QuizCubit>(context, listen: true).questionNumber - 1].option1!.h;
      case 1:
        return isenglish ? widget.listofquestionsdata![BlocProvider.of<QuizCubit>(context, listen: true).questionNumber - 1].option2!.e : widget.listofquestionsdata![BlocProvider.of<QuizCubit>(context, listen: true).questionNumber - 1].option2!.h;
      case 2:
        return isenglish ? widget.listofquestionsdata![BlocProvider.of<QuizCubit>(context, listen: true).questionNumber - 1].option3!.e : widget.listofquestionsdata![BlocProvider.of<QuizCubit>(context, listen: true).questionNumber - 1].option3!.h;
      case 3:
        return isenglish ? widget.listofquestionsdata![BlocProvider.of<QuizCubit>(context, listen: true).questionNumber - 1].option4!.e : widget.listofquestionsdata![BlocProvider.of<QuizCubit>(context, listen: true).questionNumber - 1].option4!.h;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> submitquize() async {
      int total = widget.noQuestion;
      int attempted = 0;
      context.read<QuizCubit>().answerarr.forEach((key, value) {
        if (value.isNotEmpty) {
          attempted++;
        }
      });
      return await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              //context.read<QuizCubit>().answer_arr = answer;
              return BlocProvider.value(
                value: BlocProvider.of<QuizCubit>(context),
                child: Dialog(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Languages.areyousuretosubmit,
                          style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.bold, color: ColorResources.textblack, fontSize: 16.0),
                        ),
                        const Divider(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RounderTextwidget(
                              backgroundcolor: const Color(0XFF37AEE2),
                              center: total.toString(),
                              centertextcolor: ColorResources.textWhite,
                              footer: Languages.total,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            RounderTextwidget(
                              backgroundcolor: const Color(0XFFFEB805),
                              center: attempted.toString(),
                              centertextcolor: ColorResources.textWhite,
                              footer: Languages.attempted,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            RounderTextwidget(
                              backgroundcolor: const Color(0XFFBBE3FF),
                              center: (total - attempted).toString(),
                              centertextcolor: ColorResources.textblack,
                              footer: Languages.skipped,
                            ),
                          ],
                        ),
                        //Text(context.read<QuizCubit>().answer_arr.toString()),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  Languages.resume,
                                  style: GoogleFonts.notoSansDevanagari(
                                    fontWeight: FontWeight.bold,
                                    color: ColorResources.textblack,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                context.read<QuizCubit>().submitQuiz(
                                      testid: widget.id,
                                    );
                              },
                              child: Text(
                                Languages.submit,
                                style: GoogleFonts.notoSansDevanagari(
                                  fontWeight: FontWeight.bold,
                                  color: ColorResources.buttoncolor,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ) ??
          false;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await submitquize();
            }),
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          widget.title,
          // "SD Campus Quiz",
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: SafeArea(
        child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10),
                height: MediaQuery.of(context).size.height * 0.15,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                  ),
                  color: ColorResources.buttoncolor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${widget.noQuestion} ${Languages.questions}",
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.cancel_presentation_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.noQuestion,
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          context.read<QuizCubit>().selectquestion(number: index + 1);
                          // print(object);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: ColorResources.buttoncolor,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                    color: ColorResources.textWhite,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.60,
                                child: Text(
                                  parse(parse(isenglish ? widget.listofquestionsdata![index].questionTitle!.e! : widget.listofquestionsdata![index].questionTitle!.h!).body!.text).documentElement!.text,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.notoSansDevanagari(
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: submitquize,
        child: SafeArea(
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
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Builder(builder: (context) {
                                    return GestureDetector(
                                      onTap: () => Scaffold.of(context).openDrawer(),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.menu),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "${widget.noQuestion} ${Languages.questions}",
                                            style: GoogleFonts.notoSansDevanagari(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: ColorResources.textblack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  ExamTimer(
                                    timeinsec: widget.time,
                                    style: GoogleFonts.notoSansDevanagari(
                                      color: ColorResources.buttoncolor,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (isenglish) {
                                        context.read<QuizCubit>().hindilanguage();
                                      } else {
                                        context.read<QuizCubit>().englishlanguage();
                                      }
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
                                        isenglish ? "A" : "अ",
                                        style: TextStyle(color: ColorResources.buttoncolor),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 52,
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
                            itemCount: widget.noQuestion,
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
              const SizedBox(
                height: 20,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: Align(
                          alignment: Alignment.center,
                          child: Html(
                            data: isenglish ? widget.listofquestionsdata![BlocProvider.of<QuizCubit>(context, listen: true).questionNumber - 1].questionTitle!.e! : widget.listofquestionsdata![BlocProvider.of<QuizCubit>(context, listen: true).questionNumber - 1].questionTitle!.h!,
                            onAnchorTap: (url, attributes, element) {
                              Uri openurl = Uri.parse(url!);
                              launchUrl(
                                openurl,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: FractionallySizedBox(
                          widthFactor: 0.95,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            decoration: BoxDecoration(
                              color: const Color(0xffB5CBFF).withValues(alpha: 0.26),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 4,
                                  itemBuilder: (BuildContext context, int index) {
                                    return BlocBuilder<QuizCubit, QuizState>(
                                      builder: (context, state) {
                                        if (state is PrevQuestionState) {
                                          answer = state.answer;
                                        } else if (state is NextQuestionState) {
                                          answer = state.answer;
                                        } else if (state is QuestionChange) {
                                          answer = state.answer;
                                        } else if (state is OptionsSeletedState) {
                                          answer = state.answer;
                                        }
                                        return GestureDetector(
                                          onTap: () {
                                            //flutterToast(index.toString());
                                            answer = (index + 1).toString();
                                            context.read<QuizCubit>().selectedoption(answer);
                                          },
                                          child: options(
                                            getoptions(index),
                                            index,
                                            answer.isEmpty ? 99 : int.parse(answer),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                TextButton(
                                    onPressed: () => context.read<QuizCubit>().selectedoption(''),
                                    child: Text(
                                      'Clear Option',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: ColorResources.textblack,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
            // FutureBuilder(
            //   future: RemoteDataSourceImpl().getQuestionsById(widget.id),
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     if (ConnectionState.done == snapshot.connectionState) {
            //       if (snapshot.hasData) {
            //         QuestionsById? response = snapshot.data;
            //         if (response!.status) {
            //           return
            //      body(widget.listofquestionsdata)
            //     } else {
            //       return Text(response.msg);
            //     }
            //   } else {
            //     return const Text('Server Error');
            //   }
            // } else {
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
            //},
            //),
            ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      _qnumbercontroller.position.animateTo(contentSize * BlocProvider.of<QuizCubit>(context, listen: false).questionNumber / widget.noQuestion - _qnumbercontroller.position.viewportDimension, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
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
                  // print("*" * 100);
                  // print(state);
                  // print("*" * 100);
                  if (state is SubmitSucessState) {
                    submitloading(context);
                    RemoteDataSourceImpl().getrResultById(widget.id, null).then((value) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen(index: 3)));
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => SummaryScreen(
                                name: widget.title,
                                data: value.data,
                              )));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => const HomeScreen(index: 2),
                      // ));
                    });
                  } else if (state is SubmitLoadindState) {
                    submitloading(context);
                  } else if (state is QuizLoading) {
                    Preferences.onLoading(context);
                  } else if (state is EnglishQuestionState) {
                    isenglish = true;
                  } else if (state is HindiQuestionState) {
                    isenglish = false;
                  } else if (state is SubmiterrorsState) {
                    Preferences.hideDialog(context);
                  }
                },
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResources.buttoncolor,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    submitquize();
                    //context.read<QuizCubit>().submitQuiz(testid: widget.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                    child: Text(
                      Languages.submit,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor: BlocProvider.of<QuizCubit>(context, listen: true).questionNumber < widget.noQuestion ? ColorResources.buttoncolor : ColorResources.gray,
                child: IconButton(
                  padding: const EdgeInsets.only(left: 5),
                  onPressed: () {
                    if (BlocProvider.of<QuizCubit>(context, listen: false).questionNumber < widget.noQuestion) {
                      context.read<QuizCubit>().nextquestion(answer);
                      answer = "";
                    }
                    // Get the full content height.
                    final contentSize = _qnumbercontroller.position.viewportDimension + _qnumbercontroller.position.maxScrollExtent;
                    _qnumbercontroller.position.animateTo(
                        // Estimate the target scroll position.
                        contentSize * BlocProvider.of<QuizCubit>(context, listen: false).questionNumber / widget.noQuestion - 96.0,
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

  submitloading(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                "Few minutes, your result is ready.",
                style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.bold, color: ColorResources.textblack, fontSize: 16.0),
              ),
              const Divider(),
              const SizedBox(
                  height: 100,
                  child: Center(
                      child: Icon(
                    Icons.alarm_sharp,
                    size: 30,
                  )))
            ]),
          ),
        );
      },
    );
  }

  Widget options(option, index, answerselect) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      //padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorResources.gray,
            offset: Offset.fromDirection(0.9, 2.0),
            blurRadius: 5.0,
          )
        ],
        border: Border.all(
          color: (index + 1) == answerselect ? ColorResources.textblack : Colors.transparent,
        ),
        color: ColorResources.textWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Radio(
              fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return ColorResources.textblack;
                  //return Colors.green[700]!;
                }
                return ColorResources.textblack;
              }),
              value: (index + 1).toString(),
              groupValue: answer,
              onChanged: (value) {
                answer = value.toString();
                context.read<QuizCubit>().selectedoption(answer);
                // print(answer);
              }),
          Expanded(
            //width: MediaQuery.of(context).size.width * 0.60,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Html(
                data: option,
                onAnchorTap: (url, attributes, element) {
                  Uri openurl = Uri.parse(url!);
                  launchUrl(
                    openurl,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget numberofQuestion(index, currentquesionnum) {
    return Container(
      width: 40,
      height: 40,
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

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({required this.detachedCallBack});
  final void detachedCallBack;
}
