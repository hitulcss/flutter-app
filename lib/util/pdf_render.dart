import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';

class PdfRenderScreen extends StatelessWidget {
  final String name;
  final String filePath;
  final bool isoffline;
  const PdfRenderScreen({
    super.key,
    required this.name,
    required this.filePath,
    required this.isoffline,
  });
  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "app_pdf_view", parameters: {
      "file_name": name,
      "type_view": isoffline ? "offline" : "online",
    });
    // print(isoffline);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          name,
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.grey,
      body: isoffline
          ? PdfViewer.openFile(filePath)
          : FutureBuilder<File>(
              future: DefaultCacheManager().getSingleFile(filePath),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return PdfViewer.openFile(snapshot.data!.path);
                  } else {
                    // print(filePath);
                    // print(snapshot.error);
                    return ErrorWidgetapp(image: SvgImages.error404, text: "dsa");
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
