import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/locked_content_popup.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/pdf_render.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';

class ListOfDppScreen extends StatelessWidget {
  final String batchId;
  final String subjectId;
  final Data datas;
  const ListOfDppScreen({
    super.key,
    required this.batchId,
    required this.subjectId,
    required this.datas,
  });
  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: "List of DPP Screen",
      parameters: {
        "batchId": batchId,
        "subjectId": subjectId,
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("DPP's"),
      ),
      body: FutureBuilder(
        future: RemoteDataSourceImpl().getdppbeforebatch(batchid: batchId, subjectId: subjectId),
        builder: (context, snapshot) => snapshot.data?.data?.isEmpty ?? true
            ? EmptyWidget(image: SvgImages.dppNoteslive, text: Preferences.appString.noDPPs ?? "There is no DPP")
            : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data?.data?.length ?? 0,
                itemBuilder: (context, index) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Text(
                        snapshot.data!.data![index].title!,
                        style: TextStyle(
                          color: ColorResources.textblack,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                      child: ListView.builder(
                          itemCount: snapshot.data?.data?[index].res?.length ?? 0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, rindex) {
                            final data = snapshot.data?.data?[index].res![rindex];
                            return InkWell(
                              onTap: () {
                                if (data?.file?.fileLoc?.trim().isEmpty ?? true) {
                                  lockedContentPopup(context: context, data: datas, place: "Notes");
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PdfRenderScreen(
                                          name: data?.resourceTitle ?? "",
                                          filePath: data?.file?.fileLoc ?? "",
                                          isoffline: false,
                                        ),
                                      ));
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: ColorResources.borderColor),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: CachedNetworkImage(
                                          height: 30,
                                          placeholder: (context, url) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                          imageUrl: SvgImages.pdfimage,
                                        )),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data?.resourceTitle ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.notoSansDevanagari(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: ColorResources.gray,
                                            ),
                                          ),
                                          Text(
                                            data?.file?.fileSize ?? "",
                                            style: GoogleFonts.notoSansDevanagari(
                                              fontSize: 10,
                                              color: ColorResources.gray,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ]),
                ),
              ),
      ),
    );
  }
}
