import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/controller/auth_controller.dart';
import 'package:sd_campus_app/features/data/remote/models/stream_model.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/util/showcase_tour.dart';
import 'package:sd_campus_app/view/screens/library/pyq_notes.dart';
import 'package:sd_campus_app/view/screens/library/quiz/list_quiz_lib.dart';
import 'package:sd_campus_app/view/screens/library/see_all.dart';
import 'package:sd_campus_app/view/screens/library/syllabus_notes.dart';
import 'package:sd_campus_app/view/screens/library/topper_notes.dart';
import 'package:sd_campus_app/view/screens/library/youtube/youtube_learning.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LibraryHomeScreen extends StatefulWidget {
  const LibraryHomeScreen({super.key});

  @override
  State<LibraryHomeScreen> createState() => _LibraryHomeScreenState();
}

class _LibraryHomeScreenState extends State<LibraryHomeScreen> {
  List<StreamDataModel> catagory = [];
  bool isLoading = true;
  @override
  initState() {
    getCatagory();

    super.initState();
  }

  getCatagory() async {
    StreamModel data = await AuthController().getStream();
    catagory = data.data ?? [];
    if (mounted) {
      safeSetState(() {
        isLoading = false;
      });
      List<String> keywords = SharedPreferenceHelper.getStringList(Preferences.showTour);
      if (!keywords.contains(Preferences.showTourLibrary)) {
        ShowCaseWidget.of(context).startShowCase([
          libraryTestCardKey,
          libraryNoteCardKey,
          libraryPyqsCardKey,
          librarySyllabusCardKey,
          libraryVideoLearnCardKey
        ]);
        SharedPreferenceHelper.setStringList(Preferences.showTour, keywords..add(Preferences.showTourLibrary));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Preferences.appString.library ?? 'Library'),
          // actions: [
          //   IconButton(
          //     icon: Iconify(Ri.question_line),
          //     onPressed: () {},
          //   ),
          // ],
        ),
        body: Skeletonizer(
          enabled: isLoading,
          containersColor: ColorResources.borderColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  Showcase(
                    titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                    key: libraryTestCardKey,
                    title: Preferences.apptutor.libraryTestCardKey?.title,
                    description: Preferences.apptutor.libraryTestCardKey?.des ?? "Practice Tests (Quizzes)",
                    child: card(
                      title: Preferences.appString.libQuiz ?? "Practice Tests (Quizzes)",
                      onTapViewAll: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => SeeAllScreen(
                                  title: Preferences.appString.libQuiz ?? "Practice Tests (Quizzes)",
                                  catagory: catagory,
                                  image: SvgImages.quizlib,
                                  onTap: (int index) {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) => ListQuizLib(
                                          title: catagory[index].title ?? "Quiz",
                                          streamDataModel: catagory[index],
                                        ),
                                      ),
                                    );
                                  },
                                )));
                      },
                      cardimage: SvgImages.quizlib,
                      cardontap: (int index) {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => ListQuizLib(
                                  title: catagory[index].title ?? "Quiz",
                                  streamDataModel: catagory[index],
                                )));
                      },
                      cardnameOpption: "Quiz",
                    ),
                  ),
                  Showcase(
                    titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                    key: libraryNoteCardKey,
                    title: Preferences.apptutor.libraryNoteCardKey?.title,
                    description: Preferences.apptutor.libraryNoteCardKey?.des ?? "Topper Notes",
                    child: card(
                      title: Preferences.appString.libtoppernotes ?? "Topper notes",
                      onTapViewAll: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => SeeAllScreen(
                              title: Preferences.appString.libtoppernotes ?? "Topper notes",
                              catagory: catagory,
                              image: SvgImages.toppernotes,
                              onTap: (int index) {
                                Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => TopperNotesScreen(
                                    title: catagory[index].title ?? "Topper notes",
                                    streamDataModel: catagory[index],
                                  ),
                                ));
                              },
                            ),
                          ),
                        );
                      },
                      cardimage: SvgImages.toppernotes,
                      cardontap: (int index) {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => TopperNotesScreen(
                              title: catagory[index].title ?? "Topper notes",
                              streamDataModel: catagory[index],
                            ),
                          ),
                        );
                      },
                      cardnameOpption: "Topper notes",
                    ),
                  ),
                  Showcase(
                    titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                    key: libraryPyqsCardKey,
                    title: Preferences.apptutor.libraryPyqsCardKey?.title,
                    description: Preferences.apptutor.libraryPyqsCardKey?.des ?? "Previous Year Questions (PYQs)",
                    child: card(
                        title: Preferences.appString.libPyqs ?? "PYQ’s",
                        onTapViewAll: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => SeeAllScreen(
                                  title: Preferences.appString.libPyqs ?? "PYQ’s",
                                  catagory: catagory,
                                  image: SvgImages.pyqslib,
                                  onTap: (int index) {
                                    Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) => PyqNotes(
                                        title: catagory[index].title ?? "Pyqs",
                                        streamDataModel: catagory[index],
                                      ),
                                    ));
                                  }),
                            ),
                          );
                        },
                        cardimage: SvgImages.pyqslib,
                        cardontap: (int index) => Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => PyqNotes(
                                  title: catagory[index].title ?? "Pyqs",
                                  streamDataModel: catagory[index],
                                ))),
                        cardnameOpption: "PYQ’s"),
                  ),
                  Showcase(
                    titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                    key: librarySyllabusCardKey,
                    title: Preferences.apptutor.librarySyllabusCardKey?.title,
                    description: Preferences.apptutor.librarySyllabusCardKey?.des ?? "Syllabus ",
                    child: card(
                        title: Preferences.appString.libSyllabus ?? "Syllabus",
                        onTapViewAll: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => SeeAllScreen(
                                  title: Preferences.appString.libSyllabus ?? "Syllabus",
                                  catagory: catagory,
                                  image: SvgImages.syllabuslib,
                                  onTap: (int index) {
                                    Navigator.of(context).push(CupertinoPageRoute(
                                        builder: (context) => SyllabusNotes(
                                              title: catagory[index].title ?? "Syllabus",
                                              streamDataModel: catagory[index],
                                            )));
                                  })));
                        },
                        cardimage: SvgImages.syllabuslib,
                        cardontap: (int index) => Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => SyllabusNotes(
                                  title: catagory[index].title ?? "Syllabus",
                                  streamDataModel: catagory[index],
                                ))),
                        cardnameOpption: "Syllabus"),
                  ),
                  Showcase(
                    titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          titleAlignment: Alignment.centerLeft,
                    key: libraryVideoLearnCardKey,
                    title: Preferences.apptutor.libraryVideoLearnCardKey?.title,
                    description: Preferences.apptutor.libraryVideoLearnCardKey?.des ?? "Videos Learning",
                    child: card(
                        title: Preferences.appString.libyoutubevideo ?? "Videos Learning",
                        onTapViewAll: () => Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => SeeAllScreen(
                                  title: Preferences.appString.libyoutubevideo ?? "Videos Learning",
                                  catagory: catagory,
                                  image: SvgImages.videolearning,
                                  onTap: (int index) => Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => YoutubeLearningScreen(
                                        title: catagory[index].title ?? "Youtube Learning",
                                        streamDataModel: catagory[index],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        cardimage: SvgImages.videolearning,
                        cardontap: (index) => Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => YoutubeLearningScreen(
                                  title: catagory[index].title ?? "Youtube Learning",
                                  streamDataModel: catagory[index],
                                ),
                              ),
                            ),
                        cardnameOpption: "Videos Learning"),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget card({required String title, required void Function() onTapViewAll, required String cardimage, required void Function(int index) cardontap, required String cardnameOpption}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorResources.borderColor),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: onTapViewAll,
                child: Text(
                  Preferences.appString.libViewAll ?? "View all",
                  style: TextStyle(color: ColorResources.buttoncolor),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        SizedBox(
          height: 160,
          child: ListView.separated(
              padding: EdgeInsets.only(bottom: 15, top: 5, left: 15),
              itemCount: catagory.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => SizedBox(
                    width: 10,
                  ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => cardontap(index),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 150, maxHeight: 140),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white, boxShadow: [
                      BoxShadow(spreadRadius: 0, color: ColorResources.borderColor, blurRadius: 10, offset: Offset(4, 4))
                    ]),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                      child: Column(
                        children: [
                          Image.network(
                            cardimage,
                            height: 100,
                            width: 100,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                catagory[index].title ?? cardnameOpption,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ]),
    );
  }
}
