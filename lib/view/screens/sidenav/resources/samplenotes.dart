import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/resources/resources_data_sources_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/notes_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/resourcespdfwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/search_bar_widget.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/localfiles.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';

class SampleNotesScreen extends StatefulWidget {
  const SampleNotesScreen({super.key});

  @override
  State<SampleNotesScreen> createState() => _SampleNotesScreenState();
}

class _SampleNotesScreenState extends State<SampleNotesScreen> {
  final ResourceDataSourceImpl resourceDataSourceImpl = ResourceDataSourceImpl();
  @override
  void initState() {
    analytics.logEvent(name: "app_ncert");
    Localfilesfind.initState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          Preferences.appString.ncertNotes ?? Languages.samplenote,
          style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
        ),
      ),
      body: FutureBuilder<NotesModel>(
          future: resourceDataSourceImpl.getNotes(filter: 'sample'),
          builder: (context, snapshots) {
            if (ConnectionState.done == snapshots.connectionState) {
              if (snapshots.hasData) {
                NotesModel? response = snapshots.data;
                if (response!.status) {
                  List<NotesDataModel> resources = response.data;
                  resources.sort((a, b) => a.title.compareTo(b.title));
                  // print(resources.map((e) => e.title).toList());
                  return NotesWidget(
                    resources: resources,
                    heading: Preferences.appString.ncertNotes ?? Languages.samplenote,
                  );
                } else {
                  return Text(response.msg);
                }
              } else {
                return Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.6, width: MediaQuery.of(context).size.width * 0.8, child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"))
                    //Text('Pls Refresh (or) Reopen App'),
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

class NotesWidget extends StatefulWidget {
  final List<NotesDataModel> resources;
  final String heading;
  const NotesWidget({super.key, required this.resources, required this.heading});
  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  String filterText = '';
  late List<NotesDataModel> resources = widget.resources;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Languages.shortnotes == widget.heading
                ? Container()
                : SearchBarWidget(
                    searchText: widget.heading,
                    onChanged: (String value) {
                      safeSetState(() {
                        filterText = value;
                        resources = widget.resources
                            .where(
                              (element) => element.title.toLowerCase().contains(
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
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: resources.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ResourcesContainerWidget(
                          resourcetype: resources[index].resourcetype,
                          title: resources[index].title,
                          uploadFile: resources[index].fileUrl.fileLoc,
                          fileSize: resources[index].fileUrl.fileSize ?? 0.toString(),
                        );
                      },
                    )
                  : SizedBox(
                      height: 400,
                      child: Center(
                        child: EmptyWidget(image: SvgImages.emptyresource, text: Preferences.appString.noResources ?? Languages.noresources),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
