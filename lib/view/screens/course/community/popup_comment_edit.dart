import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_community_comments.dart';
import 'package:sd_campus_app/features/presentation/bloc/batch_community/batch_community_bloc.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

class PopupCommentEdit extends StatefulWidget {
  final Comment? comment;
  final Reply? reply;
  final bool isCommentEdit;
  final String communityId;
  const PopupCommentEdit({
    super.key,
    this.comment,
    this.reply,
    required this.isCommentEdit,
    required this.communityId,
  });

  @override
  State<PopupCommentEdit> createState() => _PopupCommentEditState();
}

class _PopupCommentEditState extends State<PopupCommentEdit> {
  TextEditingController commentController = TextEditingController();
  TextEditingController replyController = TextEditingController();
  XFile? file;
  bool isImageRemoved = false;
  @override
  void initState() {
    super.initState();
    analytics.logEvent(name: "PopupCommentEdit");
    if (widget.isCommentEdit) {
      commentController.text = widget.comment?.cmntsMsg ?? "";
      isImageRemoved = widget.comment?.image?.isEmpty ?? true;
    } else {
      commentController.text = widget.comment?.cmntsMsg ?? "";
      replyController.text = widget.reply != null ? (widget.reply?.cmntsMsg ?? "") : "";
    }
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
    replyController.dispose();
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
              widget.isCommentEdit
                  ? widget.comment != null
                      ? 'Edit Comment'
                      : "Comment"
                  : widget.reply != null
                      ? 'Edit Reply'
                      : 'Reply',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          if (commentController.text.trim().isNotEmpty) ...[
            Divider(),
            Row(
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
                      border: Border.all(color: ColorResources.borderColor),
                      color: Colors.white,
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
          if (!widget.isCommentEdit && replyController.text.isNotEmpty) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(
                      SharedPreferenceHelper.getString(Preferences.profileImage) ?? "",
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
                                      "${SharedPreferenceHelper.getString(Preferences.name) ?? ""} . ",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ]),
                                const SizedBox(height: 5),
                                Text(
                                  widget.isCommentEdit ? commentController.text : replyController.text,
                                  style: const TextStyle(fontSize: 12),
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
            ),
          ],
          // Text(widget.comment?.cmntsMsg ?? "",
          //     style: TextStyle(
          //       fontWeight: FontWeight.w500,
          //       fontSize: 12,
          //     )),

          Divider(),
          TextField(
            controller: widget.isCommentEdit ? commentController : replyController,
            onChanged: (value) {
              safeSetState(() {});
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: widget.isCommentEdit ? 'Comment' : 'Reply',
              suffixIcon: widget.isCommentEdit
                  ? GestureDetector(
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
                      ))
                  : null,
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
                      final replyText = replyController.text.trim();

                      if (widget.isCommentEdit) {
                        if (commentText.isNotEmpty) {
                          if (widget.comment != null) {
                            await _editComment(commentText);
                          } else {
                            _addComment(commentText, widget.communityId, file: file);
                          }
                        } else {
                          flutterToast("Comment can't be empty");
                        }
                      } else if (widget.reply == null) {
                        if (replyText.isNotEmpty) {
                          await _postReply(replyText);
                        } else {
                          flutterToast("Reply can't be empty");
                        }
                      } else {
                        if (replyText.isNotEmpty) {
                          await _editReply(replyText);
                        } else {
                          flutterToast("Reply can't be empty");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: ColorResources.buttoncolor,
                    ),
                    child: Text(
                      widget.isCommentEdit
                          ? widget.comment != null
                              ? 'Update'
                              : "Comment"
                          : widget.reply != null
                              ? 'Update'
                              : 'Reply',
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

  Future<void> _addComment(String message, String postId, {XFile? file}) async {
    final newComment = await RemoteDataSourceImpl().postCommunityComments(msg: message, batchCommunityId: postId, file: file);
    if (newComment != null) {
      BlocProvider.of<BatchCommunityBloc>(context).add(
        PostCommunityComment(
          msg: message,
          comment: newComment,
          communityId: widget.communityId,
        ),
      );
    }
    Navigator.of(context).pop();
  }

  Future<void> _editComment(String message) async {
    final editedComment = await RemoteDataSourceImpl().editCommunityComments(
      commentId: widget.comment?.commentId ?? "",
      msg: message,
      image: isImageRemoved ? "" : widget.comment?.image ?? "",
      file: file,
    );

    if (editedComment != null) {
      BlocProvider.of<BatchCommunityBloc>(context).add(
        EditCommunityComment(
          commentId: widget.comment?.commentId ?? "",
          msg: message,
          communityId: widget.communityId,
          comment: editedComment,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _postReply(String message) async {
    final newReply = await RemoteDataSourceImpl().postCommunityCommentsReply(
      commentId: widget.comment?.commentId ?? "",
      msg: message,
    );

    if (newReply != null) {
      BlocProvider.of<BatchCommunityBloc>(context).add(
        PostReplyCommunityComment(
          communityId: widget.communityId,
          commentId: widget.comment?.commentId ?? "",
          msg: message,
          reply: newReply,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _editReply(String message) async {
    final editedReply = await RemoteDataSourceImpl().editCommunityCommentsReply(
      replyId: widget.reply?.replyId ?? "",
      msg: message,
    );

    if (editedReply != null) {
      BlocProvider.of<BatchCommunityBloc>(context).add(
        EditReplyCommunityComment(
          replyCommentId: widget.reply?.replyId ?? "",
          commentId: widget.comment?.commentId ?? "",
          msg: message,
          communityId: widget.communityId,
          reply: editedReply,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
