import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/stream_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/resourcespdfwidget_plane.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';

class PyqNotes extends StatefulWidget {
  final String title;
  final StreamDataModel streamDataModel;
  const PyqNotes({super.key, required this.title, required this.streamDataModel});

  @override
  State<PyqNotes> createState() => _PyqNotesState();
}

class _PyqNotesState extends State<PyqNotes> {
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
                    future: RemoteDataSourceImpl().getPyqsRequest(subCategory: selected.id ?? "", catagory: widget.streamDataModel.sId ?? ""),
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
                        return snapshot.data?.data?.isEmpty ?? true
                            ? EmptyWidget(image: SvgImages.dppNoteslive, text: "No Notes")
                            : ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 5,
                                    ),
                                itemCount: snapshot.data?.data?.length ?? 0,
                                itemBuilder: (context, index) => Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: ResourcesDownloadWidget(
                                          title: (snapshot.data?.data?[index].title ?? "") * 10,
                                          uploadFile: snapshot.data?.data?[index].fileUrl?.fileLoc ?? "",
                                          resourcetype: "pdf",
                                          fileSize: "",
                                        ),
                                      ),
                                    ));
                      }
                    }),
              )
            ],
          ),
        ));
  }
}
