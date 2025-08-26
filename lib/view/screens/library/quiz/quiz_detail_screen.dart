import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/cubit/quiz_library/quiz_library_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/models/library/get_quiz_question_library.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/library/quiz/quiz_page.dart';
import 'package:url_launcher/url_launcher.dart';

class QuizDetailsScreenLib extends StatelessWidget {
  final int noQuestion;
  final String id;
  final String title;
  final bool isAttempted;
  final bool isLibrary;

  const QuizDetailsScreenLib({
    super.key,
    required this.title,
    required this.id,
    required this.noQuestion,
    this.isAttempted = false,
    this.isLibrary = false,
  });
  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "app_quize_detail", parameters: {
      "id": id,
      "title": title,
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          title,
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: [
        //   if (shareLink.isNotEmpty)
        //     IconButton(
        //       onPressed: () {
        //         try {
        //           Share.share("$shareText\n$shareLink");
        //         } catch (e) {
        //           // print(e);
        //         }
        //       },
        //       icon: const Icon(Icons.share),
        //     ),
        // ],
      ),
      body: FutureBuilder(
          future: RemoteDataSourceImpl().getQuizbyid(id: id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ErrorWidgetapp(
                image: "",
                text: "",
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: snapshot.data?.data?.quizBanner ?? "",
                    errorWidget: (context, url, error) => SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            // color: ColorResources.gray.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorResources.borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "-ve",
                                    style: GoogleFonts.notoSansDevanagari(color: ColorResources.buttoncolor, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(Languages.negtiveMarketing),
                                ],
                              ),
                              Switch(
                                value: snapshot.data?.data?.isNegative ?? false,
                                activeColor: ColorResources.buttoncolor,
                                trackColor: WidgetStateProperty.resolveWith((state) {
                                  if (state.contains(WidgetState.selected)) {
                                    return Colors.white;
                                  } else {
                                    return Colors.grey[300];
                                  }
                                }),
                                trackOutlineColor: WidgetStateProperty.all(Colors.grey),
                                onChanged: (value) {},
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Text(
                        //   "Brief explanation about this quiz",
                        //   style: GoogleFonts.notoSansDevanagari(
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.grey[800],
                        //     fontSize: 16,
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: ColorResources.gray.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: ColorResources.buttoncolor), child: const Icon(Icons.sticky_note_2_outlined, color: Colors.white)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "$noQuestion ${Languages.questions}",
                                    style: GoogleFonts.notoSansDevanagari(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                              ),
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: ColorResources.buttoncolor),
                                      child: const Icon(
                                        Icons.access_time,
                                        color: Colors.white,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${snapshot.data?.data?.quizDuration} Min",
                                    style: GoogleFonts.notoSansDevanagari(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Please read the text below carefully so you can understand it",
                          style: GoogleFonts.notoSansDevanagari(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          // padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            color: ColorResources.gray.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Html(
                            shrinkWrap: true,
                            data: snapshot.data?.data?.quizDesc ?? "descration",
                            style: {
                              "img": Style(
                                width: Width(MediaQuery.of(context).size.width * 0.9),
                              ),
                            },
                            onAnchorTap: (url, attributes, element) {
                              Uri openurl = Uri.parse(url!);
                              launchUrl(
                                openurl,
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorResources.buttoncolor,
                                    shape: const StadiumBorder(),
                                  ),
                                  onPressed: () async {
                                    analytics.logEvent(
                                      name: "app_quiz_attempt",
                                      parameters: {
                                        "id": id,
                                        "name": title,
                                      },
                                    );
                                    Preferences.onLoading(context);
                                    try {
                                      GetQuizQuestionLibrary resp;
                                      if (isLibrary) {
                                        resp = await RemoteDataSourceImpl().getLibraryQuizQuestionRequest(quizId: id);
                                      } else {
                                        resp = await RemoteDataSourceImpl().getQuestionsById(id);
                                      }
                                      Preferences.hideDialog(context);
                                      if (resp.status!) {
                                        // print(startdate);
                                        context.read<QuizLibraryCubit>().questionNumber = 1;
                                        context.read<QuizLibraryCubit>().answerarr.clear();
                                        context.read<QuizLibraryCubit>().init(resp.data?.length ?? 0);
                                        // print(context.read<QuizLibraryCubit>().answerarr);
                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (context) => QuizPageScreen(
                                              title: title,
                                              listofquestionsdata: resp.data,
                                              noQuestion: resp.data?.length ?? 0,
                                              id: id,
                                              time: Duration(
                                                minutes: int.parse(snapshot.data?.data?.quizDuration ?? "0"),
                                              ).inSeconds,
                                              isAttempted: isAttempted,
                                            ),
                                          ),
                                        );
                                      } else {
                                        flutterToast(resp.msg!);
                                      }
                                    } catch (e) {
                                      log(e.toString());
                                      Preferences.hideDialog(context);
                                      flutterToast("Something went wrong");
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                                    child: Text(
                                      "start",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
