import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/features/data/remote/models/base_model.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';

class LectureReportScreen extends StatefulWidget {
  final String id;
  final dynamic cubit;
  final bool? isyoutube;
  const LectureReportScreen({super.key, required this.id, required this.cubit, this.isyoutube});

  @override
  State<LectureReportScreen> createState() => _LectureReportScreenState();
}

class _LectureReportScreenState extends State<LectureReportScreen> {
  String selectedResone = "";
  final TextEditingController _reportController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: ColorResources.textWhite,
          boxShadow: [
            BoxShadow(
              color: ColorResources.borderColor,
              spreadRadius: 0,
              blurRadius: 50,
              offset: const Offset(0, 4), // changes position of shadow
            )
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "Tell us about the issue",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "Harrasment or hateful speech",
                          title: Text(
                            "Harrasment or hateful speech",
                            style: TextStyle(fontSize: 14),
                          ),
                          groupValue: selectedResone,
                          onChanged: (value) {
                            safeSetState(() {
                              selectedResone = value.toString();
                            });
                          }),
                      RadioListTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "Violence or physical harm",
                          title: Text(
                            "Violence or physical harm",
                            style: TextStyle(fontSize: 14),
                          ),
                          groupValue: selectedResone,
                          onChanged: (value) {
                            safeSetState(() {
                              selectedResone = value.toString();
                            });
                          }),
                      RadioListTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "Suspicious, spam, or fake",
                          title: Text(
                            "Suspicious, spam, or fake",
                            style: TextStyle(fontSize: 14),
                          ),
                          groupValue: selectedResone,
                          onChanged: (value) {
                            safeSetState(() {
                              selectedResone = value.toString();
                            });
                          }),
                      RadioListTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "Adult content",
                          title: Text(
                            "Adult content",
                            style: TextStyle(fontSize: 14),
                          ),
                          groupValue: selectedResone,
                          onChanged: (value) {
                            safeSetState(() {
                              selectedResone = value.toString();
                            });
                          }),
                      RadioListTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "Other",
                          title: Text(
                            "Other",
                            style: TextStyle(fontSize: 14),
                          ),
                          groupValue: selectedResone,
                          onChanged: (value) {
                            safeSetState(() {
                              selectedResone = value.toString();
                            });
                          }),
                      if (selectedResone == "Other")
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextField(
                            controller: _reportController,
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Tell us more about the issue.",
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorResources.buttoncolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (selectedResone.isNotEmpty) {
                          final reportMsg = selectedResone == "Other" ? _reportController.text.trim() : selectedResone;
                          if (reportMsg.isNotEmpty) {
                            analytics.logEvent(name: "reported", parameters: {
                              'message': reportMsg
                            });
                            BaseModel data = widget.isyoutube ?? false ? await RemoteDataSourceImpl().submitReportVideoLearingLibrary(videoId: widget.id, comment: reportMsg) : await RemoteDataSourceImpl().postReportRequest(lectureId: widget.id, msg: reportMsg);
                            if (data.status) {
                              flutterToast(data.msg);
                              try {
                                widget.cubit.isreported = false;
                                widget.cubit.statecall();
                                log("called");
                              } catch (e) {
                                if (kDebugMode) {
                                  print("error");
                                }
                              }
                              _reportController.clear();
                            } else {
                              flutterToast(data.msg);
                            }
                          } else {
                            flutterToast("Please enter your report.");
                          }
                        } else {
                          flutterToast("Please select a reason");
                        }
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: ColorResources.textWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
