// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';

class ReportScreen extends StatelessWidget {
  final String id;
  final bool isreport;
  ReportScreen({
    super.key,
    required this.id,
    required this.isreport,
  });
  final TextEditingController questioncontroller = TextEditingController();
  final TextEditingController desccontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          isreport ? 'Report' : "Ask A Doubts",
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Please fill the form.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xffB5CBFF).withValues(alpha: 0.26),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Which question You Issue ?",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: questioncontroller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorResources.textWhite,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorResources.gray, width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    Languages.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: desccontroller,
                    minLines: 5,
                    maxLines: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorResources.textWhite,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorResources.gray, width: 1.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorResources.buttoncolor,
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                submitdata(context: context, id: id, question: questioncontroller.text, desc: desccontroller.text, isreport: isreport);
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    Languages.submit,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  submitdata({required String id, required String question, required String desc, required bool isreport, required BuildContext context}) async {
    Preferences.onLoading(context);
    try {
      Response response = isreport ? await RemoteDataSourceImpl().postreport(id: id, question: question, desc: desc) : await RemoteDataSourceImpl().postaskdoubt(id: id, question: question, desc: desc);
      if (response.statusCode == 200) {
        questioncontroller.clear();
        desccontroller.clear();
        Preferences.hideDialog(context);
        flutterToast(response.data['msg']);
      } else {
        Preferences.hideDialog(context);
        flutterToast(response.data['msg']);
      }
    } catch (e) {
      Preferences.hideDialog(context);
      // print(e);
      flutterToast('Server Error');
    }
  }
}
