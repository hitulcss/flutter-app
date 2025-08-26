import 'package:flutter/material.dart';
import 'package:sd_campus_app/util/color_resources.dart';

class ReportSuggestionWidget extends StatelessWidget {
  final dynamic cubit;
  const ReportSuggestionWidget({super.key, required this.cubit});
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
              blurRadius: 20,
              offset: const Offset(0, 4), // changes position of shadow
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
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
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  spacing: 10,
                  children: [
                    Text("Please follow the below steps to get your issue fixed."),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          Text("● Download the latest version of the App"),
                          Text("● Check your network connectivity"),
                          Text("● Restart your phone"),
                          Text("● Clear cache/data\n   Goo settings>android>data>clear cache"),
                          Text("● log out and log in"),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xffFFF8E7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Note: if you uninstall the App, your previous downloaded videos will get deleted.",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          cubit.isreported = true;
                          cubit.statecall();
                        },
                        style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 1, color: ColorResources.buttoncolor))),
                        child: Text(
                          "Unresolved",
                          style: TextStyle(color: ColorResources.buttoncolor),
                        )),
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Thank you"),
                          ));
                        },
                        child: Text(
                          "Resolved",
                          style: TextStyle(color: ColorResources.textWhite),
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
