import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_doubts_model.dart';
import 'package:sd_campus_app/features/presentation/bloc/batch_doubt/batch_doubt_bloc.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

class PopupDoubtCommentEdit extends StatefulWidget {
  final DoubtComment? comment;
  final String doubtId;
  const PopupDoubtCommentEdit({
    super.key,
    this.comment,
    required this.doubtId,
  });

  @override
  State<PopupDoubtCommentEdit> createState() => _PopupDoubtCommentEditState();
}

class _PopupDoubtCommentEditState extends State<PopupDoubtCommentEdit> {
  TextEditingController commentController = TextEditingController();
  XFile? file;
  bool isImageRemoved = false;
  @override
  void initState() {
    super.initState();
    analytics.logEvent(name: "doubt_comment_popup");
    if (widget.comment != null) {
      commentController.text = widget.comment?.msg ?? "";
      isImageRemoved = widget.comment?.image?.isEmpty ?? true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              widget.comment != null ? 'Edit Comment' : "Comment",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          if (commentController.text.trim().isNotEmpty) ...[
            Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(
                    widget.comment?.user?.profilePhoto ?? SharedPreferenceHelper.getString(Preferences.profileImage) ?? "",
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: ColorResources.borderColor),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Flexible(
                                  child: Text(
                                    "${widget.comment?.user?.name ?? SharedPreferenceHelper.getString(Preferences.name)} . ",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 5),
                              Text(
                                commentController.text,
                                style: const TextStyle(fontSize: 12),
                              ),
                              if (widget.comment != null && widget.comment?.image != null && (widget.comment?.image?.isNotEmpty ?? false) && file == null && !isImageRemoved)
                                Row(
                                  children: [
                                    ConstrainedBox(
                                        constraints: BoxConstraints(maxWidth: 230, maxHeight: 150),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.comment?.image ?? "",
                                        )),
                                    IconButton(
                                      onPressed: () {
                                        safeSetState(() {
                                          file = null;
                                          isImageRemoved = true;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        color: ColorResources.delete,
                                      ),
                                    )
                                  ],
                                ),
                              if (file != null)
                                Row(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(maxWidth: 230, maxHeight: 150),
                                      child: Image.file(
                                        File(file!.path),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          safeSetState(() {
                                            file = null;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.cancel_outlined,
                                          color: ColorResources.delete,
                                        ))
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],

          // Text(widget.comment?.cmntsMsg ?? "",
          //     style: TextStyle(
          //       fontWeight: FontWeight.w500,
          //       fontSize: 12,
          //     )),

          Divider(),
          TextField(
            controller: commentController,
            onChanged: (value) {
              safeSetState(() {});
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Comment',
              suffixIcon: GestureDetector(
                  onTap: () async {
                    file = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (file != null) {
                      CroppedFile? croppedFile = await ImageCropper().cropImage(sourcePath: file!.path, uiSettings: [
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
                        final cfile = File(croppedFile.path);
                        final fileSizeInBytes = await cfile.length();
                        final fileSizeInKB = fileSizeInBytes / 1024;

                        if (fileSizeInKB <= 1024) {
                          // File size is less than or equal to 1 MB
                          // print("File size is within limit: ${fileSizeInKB.toStringAsFixed(2)} KB");
                          safeSetState(() {
                            file = XFile(croppedFile.path);
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
                          file = file;
                        });
                      }
                    }
                  },
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.black,
                  )),
            ),
          ),
          SizedBox(height: 16),
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
                      "Cancel",
                      style: TextStyle(color: ColorResources.buttoncolor),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final commentText = commentController.text.trim();
                      if (commentText.isNotEmpty) {
                        if (widget.comment != null) {
                          await _editComment(commentText);
                        } else {
                          _addComment(commentText, widget.doubtId, file: file);
                        }
                      } else {
                        flutterToast("Comment can't be empty");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: ColorResources.buttoncolor,
                    ),
                    child: Text(
                      widget.comment != null ? 'Update' : 'Submit',
                      style: TextStyle(
                        color: ColorResources.textWhite,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addComment(String message, String batchDoubtId, {XFile? file}) async {
    final newComment = await RemoteDataSourceImpl().postBatchDoubtComment(msg: message, batchDoubtId: batchDoubtId, file: file);
    BlocProvider.of<BatchDoubtBloc>(context).add(
      PostDoubtComment(
        msg: message,
        comment: newComment,
        doubtId: widget.doubtId,
      ),
    );
    Navigator.of(context).pop();
  }

  Future<void> _editComment(String message) async {
    final editedComment = await RemoteDataSourceImpl().editBatchDoubtComment(
      commentId: widget.comment?.commentId ?? "",
      msg: message,
      image: isImageRemoved ? "" : widget.comment?.image ?? "",
      file: file,
    );

    BlocProvider.of<BatchDoubtBloc>(context).add(
      EditDoubtComment(
        commentId: widget.comment?.commentId ?? "",
        msg: message,
        doubtId: widget.doubtId,
        comment: editedComment,
      ),
    );
    Navigator.of(context).pop();
  }
}
