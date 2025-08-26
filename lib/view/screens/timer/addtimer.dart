// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/scheduler_data_source/scheduler_remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/mytimersmodel.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:intl/intl.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/view/screens/timer/timeropen.dart';

class AddTimerScreen extends StatefulWidget {
  const AddTimerScreen({super.key});

  @override
  State<AddTimerScreen> createState() => _AddTimerScreenState();
}

class _AddTimerScreenState extends State<AddTimerScreen> {
  DateTime initialtimer = DateTime.now();
  final schedulerRemoteDataSourceImpl = SchedulerRemoteDataSourceImpl();
  TextEditingController timenamecontroller = TextEditingController();
  // List<String>? allalarmname;
  // List<String>? allalarmtime;
  @override
  void dispose() {
    timenamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: "app_timer_list",
      screenClass: "app_AddTimerScreen",
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          Languages.timer,
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
            //fontSize: 22,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => const OpenTimerScreen(
                    time: 0,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                Languages.newtimer,
                style: GoogleFonts.notoSansDevanagari(color: ColorResources.buttoncolor, fontSize: 18),
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder<MyTimersModel>(
        future: RemoteDataSourceImpl().getMyTimer(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return snapshot.data!.data!.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        // print(allalarmtime![index]);// 2023-02-28 21:43:00.000
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorResources.textWhite,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.5),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.70,
                                      child: Text(
                                        snapshot.data!.data![index].timerTitle!,
                                        style: GoogleFonts.notoSansDevanagari(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          deleteformlist(id: snapshot.data!.data![index].id!);
                                        },
                                        icon: const Icon(Icons.close))
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  color: ColorResources.buttoncolor.withValues(alpha: 0.1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          Languages.createdate,
                                          style: GoogleFonts.notoSansDevanagari(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd-MMMM-yyyy').format(
                                            DateFormat('dd-MM-yyyy').parse(snapshot.data!.data![index].createdAt!.split(" ")[0]),
                                          ),
                                          style: GoogleFonts.notoSansDevanagari(),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      snapshot.data!.data![index].timerDuration!,
                                      style: GoogleFonts.notoSansDevanagari(
                                        fontSize: 20,
                                        color: ColorResources.textblack,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                  : EmptyWidget(
                      image: SvgImages.emptyresultcalculation,
                      text: Languages.notimer,
                    );
            } else {
              return EmptyWidget(
                image: SvgImages.emptyresultcalculation,
                text: Languages.notimer,
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  deleteformlist({required String id}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, safeSetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Languages.areyousure,
                    style: GoogleFonts.notoSansDevanagari(fontSize: 24, color: ColorResources.textblack),
                  ),
                ],
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () async {
                      Response response = await RemoteDataSourceImpl().deleteMyTimer(id: id);
                      if (response.data['status']) {
                        Navigator.of(context).pop();

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const AddTimerScreen(),
                        ));
                      } else {
                        flutterToast(response.data["msg"]);
                      }
                    },
                    child: Text(
                      Languages.yes,
                      style: GoogleFonts.notoSansDevanagari(
                        color: ColorResources.gray,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      Languages.no,
                      style: GoogleFonts.notoSansDevanagari(
                        color: ColorResources.buttoncolor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
