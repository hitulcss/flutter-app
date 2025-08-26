import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_community_model.dart';
import 'package:sd_campus_app/features/presentation/bloc/batch_community/batch_community_bloc.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';

class CreateAPostPopup extends StatefulWidget {
  final String batchId;
  final Community? community;
  final bool isMyCommunity;
  const CreateAPostPopup({
    super.key,
    required this.batchId,
    this.community,
    required this.isMyCommunity,
  });

  @override
  State<CreateAPostPopup> createState() => _CreateAPostPopupState();
}

class _CreateAPostPopupState extends State<CreateAPostPopup> {
  TextEditingController postTextEditController = TextEditingController();
  String? networkImage;
  XFile? pickedFile;

  @override
  void initState() {
    super.initState();
    analytics.logEvent(name: "CreateAPostPopup");
    if (widget.community != null) {
      postTextEditController.text = widget.community?.desc ?? "";
      networkImage = widget.community?.problemImage?.isEmpty ?? true ? null : widget.community?.problemImage;
      // print(pickedFile != null || (networkImage != null && networkImage!.trim().isNotEmpty));
    }
  }

  @override
  void dispose() {
    super.dispose();
    postTextEditController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              widget.community != null ? "Edit Post" : "Create a Post",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: Column(
                children: [
                  TextField(
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    controller: postTextEditController,
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // labelText: "Doubt",
                      hintText: "What’s on your mind?",
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
                            if (postTextEditController.text.trim().isEmpty) {
                              flutterToast("Please write something in Post");
                            } else {
                              if (widget.community == null) {
                                RemoteDataSourceImpl().postCreateACommunity(batchId: widget.batchId, desc: postTextEditController.text, file: pickedFile).then((value) {
                                  flutterToast(value.msg);
                                  if (value.status == true) {
                                    context.read<BatchCommunityBloc>().add(
                                          FetchCommunitys(
                                            batchId: widget.batchId,
                                            page: 1,
                                            isMyCommunity: widget.isMyCommunity,
                                          ),
                                        );
                                    Navigator.pop(context);
                                  }
                                });
                              } else {
                                RemoteDataSourceImpl().postEditACommunity(batchCommunityId: widget.community?.id ?? "", desc: postTextEditController.text.trim(), file: pickedFile, problemImage: pickedFile == null ? networkImage ?? "" : "").then((value) {
                                  if (value.desc != null) {
                                    context.read<BatchCommunityBloc>().add(EditCommunity(community: value));
                                  }
                                  Navigator.pop(context);
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorResources.buttoncolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
