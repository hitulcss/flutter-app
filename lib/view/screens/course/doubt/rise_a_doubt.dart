import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_doubts_model.dart';
import 'package:sd_campus_app/features/presentation/bloc/batch_doubt/batch_doubt_bloc.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';

class RiseADoubtPopup extends StatefulWidget {
  final String batchId;
  final Doubt? doubt;
  final bool isMyDoubt;
  const RiseADoubtPopup({
    super.key,
    required this.batchId,
    this.doubt,
    required this.isMyDoubt,
  });

  @override
  State<RiseADoubtPopup> createState() => _RiseADoubtPopupState();
}

class _RiseADoubtPopupState extends State<RiseADoubtPopup> {
  List<Subjects> subjects = [];
  List<Subjects> listOfLecture = [];

  Subjects? selectedSubject;
  Subjects? selectedLecture;

  TextEditingController subjectDropdownMenuController = TextEditingController();
  TextEditingController lectureDropdownMenuController = TextEditingController();
  TextEditingController doubtTextEditController = TextEditingController();

  XFile? pickedFile;
  String? networkImage;

  @override
  void initState() {
    super.initState();
    analytics.logEvent(
      name: "app_raise_a_doubt",
      parameters: {
        "batch_id": widget.batchId,
        "ismydoubt": widget.isMyDoubt.toString(),
      },
    );
    RemoteDataSourceImpl().getSubjectOfBatch(id: widget.batchId).then((value) {
      if (mounted) {
        safeSetState(() {
          subjects = value.data!.subjects?.map((e) => Subjects(subjectName: e.title ?? "", subjectId: e.id ?? "")).toList() ?? [];
          if (widget.doubt != null) {
            analytics.logEvent(
              name: "app_raise_a_edit_doubt",
              parameters: {
                'doubt_id': widget.doubt?.id?.toString() ?? "",
                "msg": widget.doubt?.desc ?? "",
              },
            );
            selectedSubject = subjects.firstWhere((element) => element.subjectName == widget.doubt?.subject);
            RemoteDataSourceImpl().getLecturesOfSubject(batchId: widget.batchId, subjectId: selectedSubject?.subjectId ?? "").then((value) {
              if (mounted) {
                safeSetState(() {
                  listOfLecture = value.map((e) => Subjects(subjectName: e.lectureTitle ?? "", subjectId: e.sId ?? "")).toList();
                  selectedLecture = listOfLecture.firstWhere((element) => element.subjectName == widget.doubt?.lectureName);
                  lectureDropdownMenuController.text = selectedLecture?.subjectName ?? "";
                });
              }
            });
          }
        });
      }
    });
    if (widget.doubt != null) {
      doubtTextEditController.text = widget.doubt?.desc ?? "";
      networkImage = widget.doubt?.problemImage?.isEmpty ?? true ? null : widget.doubt?.problemImage;
    }
  }

  @override
  void dispose() {
    super.dispose();
    subjectDropdownMenuController.dispose();
    lectureDropdownMenuController.dispose();
    doubtTextEditController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Raise a Doubt",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Divider(),
          DropdownMenu<Subjects>(
              controller: subjectDropdownMenuController,
              initialSelection: selectedSubject,
              enableSearch: true,
              enableFilter: true,
              expandedInsets: const EdgeInsets.symmetric(horizontal: 10),
              label: subjects.isEmpty ? Text("Loading...") : Text("Select Subject"),
              hintText: "Select Subject",
              dropdownMenuEntries: subjects.map((e) => DropdownMenuEntry(label: e.subjectName, value: e)).toList(),
              onSelected: (e) {
                if (mounted) {
                  safeSetState(() {
                    selectedLecture = null;
                    listOfLecture = [];
                    selectedSubject = null;
                  });
                }
                RemoteDataSourceImpl().getLecturesOfSubject(batchId: widget.batchId, subjectId: e?.subjectId ?? "").then((value) {
                  if (mounted) {
                    safeSetState(() {
                      selectedSubject = e;
                      listOfLecture = value.map((e) => Subjects(subjectName: e.lectureTitle ?? "", subjectId: e.sId ?? "")).toList();
                    });
                  }
                });
              }),
          SizedBox(
            height: 10,
          ),
          DropdownMenu<Subjects>(
              enabled: selectedSubject == null && listOfLecture.isEmpty ? false : true,
              controller: lectureDropdownMenuController,
              enableSearch: true,
              enableFilter: true,
              requestFocusOnTap: true,
              menuHeight: 200,
              expandedInsets: const EdgeInsets.symmetric(horizontal: 10),
              label: selectedSubject == null
                  ? subjects.isEmpty
                      ? Text("Loading...")
                      : Text("Select Subject First")
                  : listOfLecture.isEmpty
                      ? Text("Loading...")
                      : Text("Select Lecture"),
              hintText: "Select Lecture",
              dropdownMenuEntries: listOfLecture.map((e) => DropdownMenuEntry(label: e.subjectName, value: e)).toList(),
              onSelected: selectedSubject == null
                  ? null
                  : (e) {
                      safeSetState(() {
                        selectedLecture = e;
                      });
                      safeSetState(() {});
                      FocusScope.of(context).nextFocus();
                    }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: Column(
              children: [
                TextField(
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  controller: doubtTextEditController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    // labelText: "Doubt",
                    hintText: "Tell us more about the issue.",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    try {
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        CroppedFile? croppedFile = await ImageCropper().cropImage(sourcePath: image.path, uiSettings: [
                          AndroidUiSettings(toolbarTitle: 'Crop image', toolbarColor: Colors.white, toolbarWidgetColor: ColorResources.buttoncolor, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false, aspectRatioPresets: [
                            CropAspectRatioPreset.original,
                            CropAspectRatioPreset.square,
                            CropAspectRatioPreset.ratio3x2,
                            CropAspectRatioPreset.ratio4x3,
                            CropAspectRatioPreset.ratio16x9,
                            CropAspectRatioPreset.ratio7x5,
                            CropAspectRatioPreset.ratio5x3,
                            CropAspectRatioPreset.ratio5x4,
                          ]),
                          IOSUiSettings(
                            title: 'Cropper',
                            aspectRatioPresets: [
                              CropAspectRatioPreset.original,
                              CropAspectRatioPreset.square,
                            ],
                          ),
                        ]);
                        if (croppedFile != null) {
                          final file = File(croppedFile.path);
                          final fileSizeInBytes = await file.length();
                          final fileSizeInKB = fileSizeInBytes / 1024;

                          if (fileSizeInKB <= 1024) {
                            // File size is less than or equal to 1 MB
                            // print("File size is within limit: ${fileSizeInKB.toStringAsFixed(2)} KB");
                            safeSetState(() {
                              pickedFile = XFile(croppedFile.path);
                            });
                            // Proceed with the cropped image (display, upload, etc.)
                          } else {
                            // File size exceeds 1 MB
                            flutterToast("File size exceeds limit: ${fileSizeInKB.toStringAsFixed(2)} KB");
                            // Handle the case (e.g., show a warning to the user or prompt to crop again)
                          }
                        } else {
                          // print("Requested file size is");
                          safeSetState(() {
                            pickedFile = image;
                          });
                        }
                      }
                    } catch (e) {
                      // print(e);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(
                          color: ColorResources.borderColor,
                        )),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text("Attach Image (Optional)"),
                        Divider(),
                        if (pickedFile != null || (networkImage != null && networkImage!.trim().isNotEmpty))
                          Stack(
                            children: [
                              Container(
                                constraints: BoxConstraints(maxHeight: 200),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: networkImage != null && networkImage!.isNotEmpty
                                      ? CachedNetworkImage(imageUrl: networkImage!)
                                      : Image.file(
                                          File(pickedFile!.path),
                                        ),
                                ),
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      safeSetState(() {
                                        pickedFile = null;
                                        networkImage = null;
                                      });
                                    },
                                    child: Container(
                                        color: ColorResources.borderColor,
                                        child: Icon(
                                          Icons.cancel,
                                        )),
                                  ))
                            ],
                          ),
                        if (pickedFile == null && networkImage == null)
                          SizedBox(
                            height: 100,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    color: ColorResources.buttoncolor,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Add a Image"),
                                ],
                              ),
                            ),
                          ),
                        // Text("* You can upload up to 25MB"),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedSubject == null || selectedLecture == null) {
                            flutterToast("Please select subject and lecture");
                          } else {
                            if (widget.doubt == null) {
                              RemoteDataSourceImpl().postCreateADoubt(batchId: widget.batchId, desc: doubtTextEditController.text, lectureId: selectedLecture?.subjectId ?? "", subjectId: selectedSubject?.subjectId ?? "", file: pickedFile).then((value) {
                                flutterToast(value.msg);
                                if (value.status == true) {
                                  context.read<BatchDoubtBloc>().add(
                                        FetchDoubts(
                                          batchId: widget.batchId,
                                          page: 1,
                                          isMyDoubt: widget.isMyDoubt,
                                        ),
                                      );
                                  Navigator.pop(context, true);
                                }
                              });
                            } else {
                              RemoteDataSourceImpl().editBatchDoubt(batchDoubtId: widget.doubt?.id ?? "", problemImage: networkImage?.trim().isEmpty ?? false ? "" : networkImage ?? "", desc: doubtTextEditController.text, file: pickedFile).then((value) {
                                if (value != null) {
                                  context.read<BatchDoubtBloc>().add(EditDoubt(doubt: value));
                                }
                                Navigator.pop(context, true);
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorResources.buttoncolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          elevation: 5,
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class Subjects {
  final String subjectName;
  final String subjectId;
  Subjects({
    required this.subjectName,
    required this.subjectId,
  });
}
