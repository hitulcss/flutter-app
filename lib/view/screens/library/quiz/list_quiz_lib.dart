import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/stream_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/util/appstring.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/bottomnav/quiz/summery_screen.dart';
import 'package:sd_campus_app/view/screens/library/quiz/quiz_detail_screen.dart';

import '../../../../features/presentation/widgets/empty_widget.dart';

class ListQuizLib extends StatefulWidget {
  final String title;
  final StreamDataModel streamDataModel;
  const ListQuizLib({super.key, required this.title, required this.streamDataModel});

  @override
  State<ListQuizLib> createState() => _ListQuizLibState();
}

class _ListQuizLibState extends State<ListQuizLib> {
  SubCategories selected = SubCategories();
  @override
  void initState() {
    super.initState();
    if (widget.streamDataModel.subCategories?.isNotEmpty ?? false) {
      selected = widget.streamDataModel.subCategories?.first ?? SubCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 5,
                    children: List.generate(
                      widget.streamDataModel.subCategories?.length ?? 0,
                      (index) => ChoiceChip(
                        selected: selected == widget.streamDataModel.subCategories?[index],
                        selectedColor: ColorResources.buttoncolor,
                        showCheckmark: false,
                        labelStyle: TextStyle(color: selected == widget.streamDataModel.subCategories?[index] ? ColorResources.textWhite : ColorResources.textblack),
                        // backgroundColor: ColorResources.textWhite,
                        onSelected: (value) {
                          safeSetState(() {
                            selected = widget.streamDataModel.subCategories?[index] ?? SubCategories();
                          });
                        },
                        label: Text(widget.streamDataModel.subCategories?[index].title ?? ""),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: FutureBuilder(
                        future: RemoteDataSourceImpl().getLibraryQuizRequest(subCategory: selected.id ?? "", catagory: widget.streamDataModel.sId ?? ""),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: ErrorWidgetapp(
                                image: SvgImages.error404,
                                text: snapshot.error.runtimeType.toString(),
                              ),
                            );
                          } else {
                            return snapshot.data?.data?.quizes?.isEmpty ?? true
                                ? EmptyWidget(image: SvgImages.emptyquiz, text: "No Quiz Found")
                                : ListView.builder(
                                    itemCount: snapshot.data?.data?.quizes?.length ?? 0,
                                    itemBuilder: (context, index) => Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: ColorResources.textWhite,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            spacing: 10,
                                            children: [
                                              Icon(Icons.list_alt),
                                              Expanded(child: Text(snapshot.data?.data?.quizes?[index].title ?? "")),
                                            ],
                                          ),
                                          Divider(),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              _iconTextWidget("${snapshot.data?.data?.quizes?[index].noOfQuestion ?? 0} Q", Icons.quiz_outlined),
                                              _iconTextWidget("${snapshot.data?.data?.quizes?[index].totalMarks ?? 0} Marks", Icons.insert_chart_outlined_outlined),
                                              _iconTextWidget("${snapshot.data?.data?.quizes?[index].duration ?? 0} Mins", Icons.history),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          snapshot.data?.data?.quizes?[index].isAttempted ?? false
                                              ? Row(
                                                  spacing: 10,
                                                  children: [
                                                    Expanded(
                                                      child: OutlinedButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder: (context) => QuizDetailsScreenLib(
                                                                noQuestion: int.parse(snapshot.data?.data?.quizes?[index].noOfQuestion ?? "0"),
                                                                id: snapshot.data?.data?.quizes?[index].quizId ?? "",
                                                                title: snapshot.data?.data?.quizes?[index].title ?? "",
                                                                isAttempted: true,
                                                                isLibrary: true,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        style: OutlinedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                          side: BorderSide(color: ColorResources.buttoncolor),
                                                        ),
                                                        child: Text(
                                                          "Re- Attempt",
                                                          style: TextStyle(color: ColorResources.buttoncolor),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Preferences.onLoading(context);
                                                          RemoteDataSourceImpl().getrResultById(snapshot.data?.data?.quizes?[index].quizId ?? "", null).then((value) {
                                                            Navigator.of(context).pop();
                                                            Navigator.of(context).push(CupertinoPageRoute(
                                                                builder: (context) => SummaryScreen(
                                                                      name: widget.title,
                                                                      data: value.data,
                                                                    )));
                                                          }).catchError((e) {
                                                            Navigator.of(context).pop();
                                                          });
                                                        },
                                                        child: Text(
                                                          "View Analysis",
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder: (context) => QuizDetailsScreenLib(
                                                                noQuestion: int.parse(snapshot.data?.data?.quizes?[index].noOfQuestion ?? "0"),
                                                                id: snapshot.data?.data?.quizes?[index].quizId ?? "",
                                                                title: snapshot.data?.data?.quizes?[index].title ?? "",
                                                                isLibrary: true,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                          "Attempt",
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                        ],
                                      ),
                                    ),
                                    // CardWidget(
                                    //   notesModel: snapshot.data?.data?.quizes?[index] ?? NotesModel(),
                                    // ),
                                  );
                          }
                        }))
              ],
            )));
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
}
