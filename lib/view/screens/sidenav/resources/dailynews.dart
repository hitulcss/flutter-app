import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/resources/resources_data_sources_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/daily_news_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/resourcespdfwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:intl/intl.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/localfiles.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

class DailyNewsScreen extends StatefulWidget {
  const DailyNewsScreen({
    super.key,
  });

  @override
  State<DailyNewsScreen> createState() => _DailyNewsScreenState();
}

class _DailyNewsScreenState extends State<DailyNewsScreen> {
  String? datetoshow;
  final ResourceDataSourceImpl resourceDataSourceImpl = ResourceDataSourceImpl();

  List<DailyNewsDataModel> listdata = [];

  @override
  void initState() {
    super.initState();
    Localfilesfind.initState();
    analytics.logEvent(name: "app_dailynews", parameters: {
      "name": SharedPreferenceHelper.getString(Preferences.name) ?? "Unknown",
      "phoneNumber": SharedPreferenceHelper.getString(Preferences.phoneNUmber) ?? "Unknown",
      "email": SharedPreferenceHelper.getString(Preferences.email) ?? "Unknown",
      "id": SharedPreferenceHelper.getString(Preferences.enrollId) ?? analytics.getSessionId().toString(),
    });
    datetoshow = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          Preferences.appString.dailyNews ?? Languages.dailynews,
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder<DailyNewsModel>(
          future: resourceDataSourceImpl.getDailyNews(),
          builder: (context, snapshots) {
            if (ConnectionState.done == snapshots.connectionState) {
              if (snapshots.hasData) {
                DailyNewsModel? response = snapshots.data;
                if (response!.status) {
                  response.data.sort(
                    (a, b) {
                      return a.createdAt.compareTo(b.createdAt);
                    },
                  );
                  for (var element in response.data) {
                    if (DateFormat("dd-MM-yyyy").parse(element.createdAt).toString().split(" ")[0] == DateFormat("dd-MM-yyyy").parse(datetoshow!).toString().split(" ")[0]) {
                      if (element.isActive) {
                        listdata.add(element);
                      }
                    }
                  }
                  return _bodyWidget(context, listdata);
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

  SizedBox _bodyWidget(BuildContext context, List<DailyNewsDataModel> resources) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            datetoshow == DateFormat('dd-MM-yyyy').format(DateTime.now()) ? Languages.newsfortoday : "News for",
            style: GoogleFonts.notoSansDevanagari(
              color: ColorResources.textblack,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorResources.buttoncolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime.now());
              if (pickedDate != null) {
                listdata.clear();
                // print(
                //     pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                // print(
                //     formattedDate); //formatted date output using intl package =>  2021-03-16
                safeSetState(() {
                  analytics.logEvent(name: "app_daily_news_of_date", parameters: {
                    "date": formattedDate.toString(),
                  });
                  datetoshow = formattedDate; //set output date to TextField value.
                });
              } else {}
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('dd-MMMM-yyyy').format(DateFormat('dd-MM-yyyy').parse(datetoshow!)),
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorResources.textWhite,
                  ),
                ),
                Icon(Icons.arrow_drop_down_outlined, color: ColorResources.textWhite)
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          resources.isEmpty
              ? SizedBox(
                  height: 400,
                  child: Center(
                    child: EmptyWidget(
                      image: SvgImages.emptyresource,
                      text: Preferences.appString.noNews ?? Languages.nonews,
                    ),
                  ),
                )
              : FractionallySizedBox(
                  widthFactor: 0.90,
                  child: ListView.builder(
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
                  ),
                ),
        ]),
      ),
    );
  }
}
