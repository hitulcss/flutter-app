import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:url_launcher/url_launcher.dart';

class ListOfAnnouncementScreen extends StatelessWidget {
  final String batchId;
  final bool isFullScreen;
  const ListOfAnnouncementScreen({super.key, required this.batchId, required this.isFullScreen});
  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'Announcement List Screen',
      parameters: {
        'batchId': batchId,
      },
    );
    return Scaffold(
      appBar: isFullScreen
          ? AppBar(
              title: Text('Announcement'),
            )
          : null,
      body: FutureBuilder(
          future: RemoteDataSourceImpl().getCourseAnnouncementRequest(id: batchId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              //print(widget.batch.batchId);
              if (snapshot.hasData) {
                return snapshot.data!.data!.isEmpty
                    ? EmptyWidget(image: SvgImages.noAccouncement, text: Preferences.appString.noAnnouncements ?? "There is no Announcements")
                    : Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: ListView.builder(
                          itemCount: snapshot.data!.data!.length,
                          itemBuilder: (context, index) => Container(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x7FD9D9D9),
                                    blurRadius: 41,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: ListTile(
                                isThreeLine: true,
                                title: Text(
                                  snapshot.data!.data![index].title!,
                                  style: TextStyle(
                                    color: ColorResources.textblack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Html(
                                      data: snapshot.data!.data![index].description,
                                      onAnchorTap: (url, attributes, element) {
                                        Uri openurl = Uri.parse(url!);
                                        launchUrl(
                                          openurl,
                                        );
                                      },
                                    ),
                                    Text(
                                      snapshot.data!.data![index].createdAt!,
                                      style: TextStyle(
                                        color: ColorResources.textblack,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
              } else {
                return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
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
