// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/short_type.dart';
import 'package:sd_campus_app/util/enum/type_of_community.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';

class CommunityReportPopup extends StatefulWidget {
  final TypeOfCommunity? typeOfCommunity;
  final TypeOfDobut? typeOfDobut;
  final ShortType? typeOfShort;
  final String id;
  const CommunityReportPopup({super.key, this.typeOfCommunity, required this.id, this.typeOfDobut, this.typeOfShort});

  @override
  State<CommunityReportPopup> createState() => _CommunityReportPopupState();
}

class _CommunityReportPopupState extends State<CommunityReportPopup> {
  String selectedResone = "";

  TextEditingController resoneTextEditingController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    resoneTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Select Report",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
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
                controller: resoneTextEditingController,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Tell us more about the issue.",
                ),
              ),
            ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(
                        width: 2,
                        style: BorderStyle.solid,
                        color: ColorResources.buttoncolor,
                      ),
                    ),
                    child: Text(
                      "CANCEL",
                      style: TextStyle(color: ColorResources.buttoncolor),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        if (selectedResone.isNotEmpty) {
                          final reportMsg = selectedResone == "Other" ? resoneTextEditingController.text.trim() : selectedResone;
                          analytics.logEvent(
                            name: "app_trying_to_report",
                            parameters: {
                              "type": widget.typeOfCommunity?.name ?? widget.typeOfDobut?.name ?? "type",
                              "reason": reportMsg,
                            },
                          );
                          if (reportMsg.isNotEmpty) {
                            _reportItem(reportMsg);
                          } else {
                            flutterToast("Please enter reason");
                          }
                        } else {
                          flutterToast("Please select a reason");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: ColorResources.buttoncolor,
                      ),
                      child: Text(
                        "REPORT",
                        style: TextStyle(color: ColorResources.textWhite),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Reports the community/comment/reply with the given [reportMsg].
  /// The type of report is determined by [widget.typeOfCommunity].
  /// After reporting, pops the dialog.
  void _reportItem(String reportMsg) {
    if (widget.typeOfCommunity != null) {
      switch (widget.typeOfCommunity!) {
        case TypeOfCommunity.community:
          RemoteDataSourceImpl().postReportCommunity(batchCommunityId: widget.id, msg: reportMsg).then((_) => Navigator.pop(context));
          break;
        case TypeOfCommunity.comment:
          RemoteDataSourceImpl().postReportComment(commentId: widget.id, msg: reportMsg).then((_) => Navigator.pop(context));
          break;
        case TypeOfCommunity.reply:
          RemoteDataSourceImpl().postReportCommentReply(replyCommentId: widget.id, msg: reportMsg).then((_) => Navigator.pop(context));
          break;
      }
    } else if (widget.typeOfDobut != null) {
      switch (widget.typeOfDobut!) {
        case TypeOfDobut.doubt:
          RemoteDataSourceImpl().postBatchDoubtReport(batchDoubtId: widget.id, reason: reportMsg).then((_) => Navigator.pop(context));
          break;
        case TypeOfDobut.comment:
          RemoteDataSourceImpl().postDoubtCommentReport(commentId: widget.id, reason: reportMsg).then((_) => Navigator.pop(context));
          break;
      }
    } else if (widget.typeOfShort != null) {
      switch (widget.typeOfShort!) {
        case ShortType.feed:
          RemoteDataSourceImpl().postReportShort(shortId: widget.id, msg: reportMsg).then((_) => Navigator.pop(context));
          break;
        case ShortType.shortComment:
          RemoteDataSourceImpl().postReportCommentShort(commentId: widget.id, msg: reportMsg).then((_) => Navigator.pop(context));
          break;
        case ShortType.shortCommentReply:
          RemoteDataSourceImpl().postReportCommentReplyShort(replyCommentId: widget.id, msg: reportMsg).then((_) => Navigator.pop(context));
          break;
        default:
      }
    }
  }
}
