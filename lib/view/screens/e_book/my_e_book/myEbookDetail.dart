// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/pdf_render.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';

class MyEBookDetailScreen extends StatelessWidget {
  final String id;
  final String name;
  const MyEBookDetailScreen({super.key, required this.id, required this.name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: FutureBuilder(
          future: RemoteDataSourceImpl().getMyEbookByIdRequest(id: id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.text_snippet_outlined),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  snapshot.data!.data!.language == "en" ? "English" : "Hindi",
                                  style: const TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.text_snippet_outlined),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${snapshot.data!.data!.chapterCount} Topics",
                                  style: const TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        snapshot.data?.data?.chapterWithTopics?.isEmpty ?? true
                            ? Text(
                                Preferences.appString.notopic ?? "No Topics Available",
                                style: const TextStyle(color: Color(0xFF333333), fontSize: 14, fontWeight: FontWeight.w400, height: 0),
                              )
                            : ExpansionPanelList.radio(
                                materialGapSize: 0,
                                expandedHeaderPadding: EdgeInsets.zero,
                                initialOpenPanelValue: snapshot.data?.data?.chapterWithTopics?.first.chapterId.toString(),
                                children: snapshot.data?.data?.chapterWithTopics
                                        ?.map((e) => ExpansionPanelRadio(
                                            value: e.chapterId.toString(),
                                            headerBuilder: (context, isExpanded) => ListTile(
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                                  title: Text(
                                                    e.chapterTitle ?? "",
                                                    style: const TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    "${e.topics?.length ?? 0} Pdfs",
                                                    style: const TextStyle(
                                                      color: Color(0xBF333333),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ),
                                            body: e.topics?.isEmpty ?? true
                                                ? Text(Preferences.appString.notopic ?? "No Topics Available")
                                                : MediaQuery.removePadding(
                                                    context: context,
                                                    removeTop: true,
                                                    removeBottom: true,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      itemCount: e.topics?.length ?? 0,
                                                      itemBuilder: (context, index) {
                                                        return ListTile(
                                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                                          leading: Container(
                                                            padding: const EdgeInsets.all(5),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(4),
                                                              color: ColorResources.buttoncolor.withValues(alpha: 0.2),
                                                            ),
                                                            clipBehavior: Clip.antiAlias,
                                                            child: Icon(
                                                              Icons.emoji_objects_outlined,
                                                              color: ColorResources.buttoncolor,
                                                            ),
                                                          ),
                                                          title: Text(
                                                            e.topics![index].topicTitle ?? "",
                                                          ),
                                                          trailing: IconButton(
                                                            onPressed: () {
                                                              Preferences.onLoading(context);
                                                              RemoteDataSourceImpl().getTopicRequest(topicId: e.topics![index].topicId ?? "", ebookId: id).then((value) {
                                                                Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => PdfRenderScreen(
                                                                      isoffline: false,
                                                                      filePath: value.data?.fileDetails?.fileUrl ?? "",
                                                                      name: value.data?.fileDetails?.name ?? "",
                                                                    ),
                                                                  ),
                                                                );
                                                              }).onError((error, stackTrace) {
                                                                Preferences.hideDialog(context);
                                                              });
                                                            },
                                                            icon: const Icon(Icons.remove_red_eye_outlined),
                                                          ),
                                                          subtitle: Text(e.topics![index].details?.size ?? ""),
                                                        );
                                                      },
                                                    ),
                                                  )))
                                        .toList() ??
                                    [],
                              )
                      ],
                    ),
                  ),
                );
              } else {
                return ErrorWidgetapp(image: SvgImages.error404, text: "something went wrong");
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
