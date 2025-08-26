import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/resources/resources_data_sources_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/resources_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/resourcespdfwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/search_bar_widget.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:intl/intl.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/localfiles.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';

class CoursesIndexResources extends StatefulWidget {
  const CoursesIndexResources({super.key});
  @override
  State<CoursesIndexResources> createState() => _CoursesIndexResourcesState();
}

class _CoursesIndexResourcesState extends State<CoursesIndexResources> {
  final ResourceDataSourceImpl resourceDataSourceImpl = ResourceDataSourceImpl();
  String? datetoshow;
  @override
  void initState() {
    Localfilesfind.initState();
    analytics.logEvent(name: "app_syllabus");
    datetoshow = DateFormat('dd-MMMM-yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          //'Course Index'
          Preferences.appString.syllabus ?? Languages.courseIndex,
          style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
        ),
      ),
      body: FutureBuilder<ResourcesModel>(
          future: resourceDataSourceImpl.getCourseIndex(),
          builder: (context, snapshots) {
            if (ConnectionState.done == snapshots.connectionState) {
              if (snapshots.hasData) {
                ResourcesModel? response = snapshots.data;
                if (response!.status!) {
                  return CourseIndexBody(resources: response.data!);
                } else {
                  return Text(response.msg!);
                }
              } else {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(
                    child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"),
                  ),
                );
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

class CourseIndexBody extends StatefulWidget {
  const CourseIndexBody({super.key, required this.resources});
  final List<ResourcesDataModle> resources;
  @override
  State<CourseIndexBody> createState() => _CourseIndexBodyState();
}

class _CourseIndexBodyState extends State<CourseIndexBody> {
  String filterText = '';
  late List<ResourcesDataModle> resources = widget.resources;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SearchBarWidget(
              searchText: Preferences.appString.syllabus ?? Languages.courseIndex,
              onChanged: (String value) {
                safeSetState(() {
                  filterText = value;
                  resources = widget.resources
                      .where(
                        (element) => element.title!.toLowerCase().contains(
                              filterText.toLowerCase(),
                            ),
                      )
                      .toList();
                });
              },
            ),
            FractionallySizedBox(
              widthFactor: 0.90,
              child: resources.isNotEmpty
                  ? ListView.builder(
                      itemCount: resources.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ResourcesContainerWidget(
                          resourcetype: resources[index].resourceType!,
                          title: resources[index].title!,
                          uploadFile: resources[index].fileUrl!.fileLoc!,
                          fileSize: resources[index].fileUrl!.fileSize ?? 0.toString(),
                        );
                      },
                    )
                  : SizedBox(
                      height: 400,
                      child: EmptyWidget(
                        image: SvgImages.emptyresource,
                        text: Preferences.appString.noResources ?? Languages.noresources,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
