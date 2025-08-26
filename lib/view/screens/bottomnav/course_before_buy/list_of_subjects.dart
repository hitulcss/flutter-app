import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/shimmer_custom.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/before_buy_navig.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/view/screens/bottomnav/course_before_buy/list_of_dpp.dart';
import 'package:sd_campus_app/view/screens/bottomnav/course_before_buy/list_of_lecture.dart';
import 'package:sd_campus_app/view/screens/bottomnav/course_before_buy/list_of_notes.dart';

class ListOfSubjectsScreen extends StatelessWidget {
  final String batchId;
  final BeforeBuyNavig beforeBuyNavig;
  final Data data;
  const ListOfSubjectsScreen({super.key, required this.batchId, required this.beforeBuyNavig, required this.data});
  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "ListOfSubjectsScreen", parameters: {
      'batchId': batchId,
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Batch of Subjects'),
      ),
      body: FutureBuilder(
          future: RemoteDataSourceImpl().getListOfSubjects(id: batchId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              return AlignedGridView.count(
                padding: const EdgeInsets.all(10),
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                shrinkWrap: true,
                itemCount: snapshot.data?.data?.length ?? 0,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => beforeBuyNavig == BeforeBuyNavig.lecture
                              ? ListOfLectureSubject(
                                  subjectName: snapshot.data?.data?[index].title ?? "",
                                  subjectId: snapshot.data?.data?[index].id ?? "",
                                  batchId: batchId,
                                  data: data,
                                )
                              : beforeBuyNavig == BeforeBuyNavig.notes
                                  ? ListOfNotesScreen(
                                      batchId: batchId,
                                      subjectId: snapshot.data?.data?[index].id ?? "",
                                      datas: data,
                                    )
                                  : ListOfDppScreen(
                                      batchId: batchId,
                                      subjectId: snapshot.data?.data?[index].id ?? "",
                                      datas: data,
                                    ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5),
                      decoration: BoxDecoration(border: Border.all(color: ColorResources.borderColor), borderRadius: BorderRadius.circular(10), color: Colors.white),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                              imageUrl: snapshot.data?.data?[index].icon ?? "",
                              height: 60,
                              width: 60,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Center(
                                    child: ShimmerCustom.rectangular(height: 30),
                                  ),
                              errorWidget: (context, url, error) => CircleAvatar(
                                    child: Text(
                                      snapshot.data?.data?[index].title?[0] ?? "s",
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ) //const Icon(Icons.error),

                              ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            snapshot.data?.data?[index].title ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              // print(snapshot.error);
              return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
            }
          }),
    );
  }
}
