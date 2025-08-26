import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/resourcespdfwidget.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';

class LectureResourceScreen extends StatelessWidget {
  const LectureResourceScreen({super.key, required this.lecture});
  final LectureDetails lecture;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: lecture.material!.fileName!.isEmpty && lecture.dpp!.fileName!.isEmpty
          ? Center(child: EmptyWidget(image: SvgImages.emptyresource, text: Languages.noresources))
          : SingleChildScrollView(
              child: Column(
                children: [
                  lecture.material!.fileName!.isEmpty ? Container() : const Align(alignment: Alignment.center, child: Text('Documents Shared with you')),
                  lecture.material!.fileName!.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                          child: ResourcesContainerWidget(
                            title: lecture.material!.fileName!,
                            uploadFile: lecture.material!.fileLoc!,
                            resourcetype: 'pdf',
                            fileSize: lecture.material!.fileSize,
                          ),
                        ),
                  lecture.dpp!.fileName!.trim().isEmpty ? Container() : const Text('DPP Shared with you'),
                  lecture.dpp!.fileName!.trim().isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                          child: ResourcesContainerWidget(
                            title: lecture.dpp!.fileName!,
                            uploadFile: lecture.dpp!.fileLoc!,
                            resourcetype: 'pdf',
                            fileSize: lecture.dpp!.fileSize,
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
