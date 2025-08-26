// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:sd_campus_app/features/cubit/quiz/quiz_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/home.dart';

class TestSubmitScreen extends StatefulWidget {
  final String id;
  final String examtype;
  final String name;
  final int time;
  final String questionPaper;
  const TestSubmitScreen({
    super.key,
    required this.id,
    required this.time,
    required this.examtype,
    required this.name,
    required this.questionPaper,
  });

  @override
  State<TestSubmitScreen> createState() => _TestSubmitScreenState();
}

class _TestSubmitScreenState extends State<TestSubmitScreen> {
  FilePickerResult? result;
  PlatformFile? file;
  bool selectfile = false;
  Future<bool> exitConfirm() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Languages.areyousuretosubmit,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      // style: ElevatedButton.styleFrom(
                      //     primary: ColorResources.buttoncolor,
                      //     shape: const StadiumBorder()),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        Languages.resume,
                        style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.bold, color: ColorResources.gray, fontSize: 14.0),
                      ),
                    ),
                    TextButton(
                      // style: ElevatedButton.styleFrom(
                      //     primary: ColorResources.buttoncolor,
                      //     shape: const StadiumBorder()),
                      onPressed: () {
                        fileupload();
                        // BlocProvider.of<QuizCubit>(context)
                        //     .submitQuizobjective(testid: widget.id);
                        Navigator.of(context).pop(true);
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
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await exitConfirm()) {
                //Navigator.of(context).pop();
              }
            }),
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          widget.name,
          style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack, fontWeight: FontWeight.bold),
        ),
      ),
      body: WillPopScope(
        onWillPop: exitConfirm,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ExamTimer(
              style: GoogleFonts.notoSansDevanagari(
                color: ColorResources.buttoncolor,
                fontSize: 16,
              ),
              timeinsec: widget.time,
            ),
            GestureDetector(
              onTap: () async {
                result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: [
                    'pdf'
                  ],
                );
                if (result != null) {
                  file = result!.files.single;
                  safeSetState(() {
                    // print(file);
                    selectfile = true;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: ColorResources.buttoncolor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'PDF',
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorResources.textWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.file_upload_outlined,
                          size: 25,
                          color: ColorResources.textWhite,
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.examtype == "objective" ? Languages.uploadomr : Languages.uploadanswersheet,
                      style: GoogleFonts.notoSansDevanagari(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            //selectfile ? Text(file!.path!) : const Text(""),
            selectfile
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: PdfViewer.openFile(
                      file!.path!,
                      params: const PdfViewerParams(),
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: FutureBuilder<File>(
                      future: DefaultCacheManager().getSingleFile(widget.questionPaper),
                      builder: (context, snapshot) => snapshot.hasData
                          ? PdfViewer.openFile(snapshot.data!.path)
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
            selectfile
                ? Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        fileupload();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: MediaQuery.of(context).size.width * 0.30,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: ColorResources.buttoncolor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              //'Sumbit'
                              Languages.submit,
                              style: GoogleFonts.notoSansDevanagari(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                            const Expanded(child: SizedBox()),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: ColorResources.textWhite,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const Text(""),
          ],
        ),
      ),
    );
  }

  fileupload() async {
    safeSetState(() {
      Preferences.onLoading(context);
    });
    try {
      Response response = await RemoteDataSourceImpl().submitanswer(file ?? "0", widget.id);
      if (response.statusCode == 200) {
        safeSetState(() {
          Preferences.hideDialog(context);
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeScreen(
            index: 2,
          ),
        ));
        flutterToast(response.data['msg']);
      } else {
        safeSetState(() {
          Preferences.hideDialog(context);
        });
        flutterToast(response.data['msg']);
      }
    } catch (error) {
      // print("*" * 100);
      // print(error.toString());
      // print("*" * 100);
      safeSetState(() {
        Preferences.hideDialog(context);
      });
      flutterToast('Server Error');
    }
  }
}

class ExamTimer extends StatefulWidget {
  final int timeinsec;
  final TextStyle? style;
  const ExamTimer({
    super.key,
    required this.timeinsec,
    required this.style,
  });

  @override
  State<ExamTimer> createState() => _ExamTimerState();
}

class _ExamTimerState extends State<ExamTimer> {
  Timer? countdownTimer;
  Duration? myDuration;

  @override
  void initState() {
    myDuration = Duration(seconds: widget.timeinsec);
    startTimer(context);
    super.initState();
  }

  @override
  void dispose() {
    countdownTimer!.cancel();
    super.dispose();
  }

  void startTimer(BuildContext context) {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    safeSetState(() {
      final seconds = myDuration!.inSeconds - reduceSecondsBy;
      if (seconds <= 0) {
        context.read<QuizCubit>().getTimer('0');
        countdownTimer!.cancel();
        Scaffold.of(context).isDrawerOpen ? Navigator.of(context).pop() : null;
        Navigator.of(context).pop();
      } else {
        myDuration = Duration(seconds: seconds);
        context.read<QuizCubit>().getTimer(myDuration?.inMinutes.toString() ?? "0");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(myDuration!.inHours.remainder(24));
    final minutes = strDigits(myDuration!.inMinutes.remainder(60));
    final seconds = strDigits(myDuration!.inSeconds.remainder(60));
    return Container(
      margin: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * 0.30,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: ColorResources.buttoncolor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(50)),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_sharp,
              size: 18,
              color: ColorResources.buttoncolor,
            ),
            const SizedBox(
              width: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                '$hours:$minutes:$seconds',
                style: widget.style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
