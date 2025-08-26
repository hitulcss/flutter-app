import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/stream_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/expandable_list.dart';
import 'package:sd_campus_app/features/presentation/widgets/resourcespdfwidget_plane.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';

class TopperNotesScreen extends StatefulWidget {
  final String title;
  final StreamDataModel streamDataModel;
  const TopperNotesScreen({
    super.key,
    required this.title,
    required this.streamDataModel,
  });

  @override
  State<TopperNotesScreen> createState() => _TopperNotesScreenState();
}

class _TopperNotesScreenState extends State<TopperNotesScreen> {
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
                    future: RemoteDataSourceImpl().getToperNotesRequest(subCategory: selected.id ?? "", catagory: widget.streamDataModel.sId ?? ""),
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
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeBottom: true,
                                    removeTop: true,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                          child: Text(snapshot.data?.data?[index].subject ?? ""),
                                        ),
                                        Divider(),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ExpandableListWidget(
                                            minlength: 3,
                                            children: List.generate(
                                              snapshot.data?.data?[index].notes?.length ?? 0,
                                              (cindex) => ResourcesDownloadWidget(
                                                title: snapshot.data?.data?[index].notes?[cindex].title ?? "",
                                                uploadFile: snapshot.data?.data?[index].notes?[cindex].fileUrl?.fileLoc ?? "",
                                                resourcetype: "pdf",
                                                fileSize: "",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      }
                    }),
              )
            ],
          ),
        ));
  }
}
