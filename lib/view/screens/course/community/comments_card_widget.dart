import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/models/get_community_comments.dart';
import 'package:sd_campus_app/features/presentation/bloc/batch_community/batch_community_bloc.dart';
import 'package:sd_campus_app/features/presentation/widgets/Community_report_popup.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/type_of_community.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/view/screens/course/community/popup_comment_edit.dart';

class CommentCardWidget extends StatefulWidget {
  final String communityId;
  final Comment comment;
  const CommentCardWidget({super.key, required this.comment, required this.communityId});

  @override
  State<CommentCardWidget> createState() => _CommentCardWidgetState();
}

class _CommentCardWidgetState extends State<CommentCardWidget> {
  bool isOpenedReply = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(
                widget.comment.user?.profilePhoto ?? SvgImages.avatar,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(children: [
                            Text(
                              "${widget.comment.user?.name ?? ""} ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.comment.user?.isVerified ?? false) ...[
                              Icon(
                                Icons.verified,
                                color: ColorResources.buttoncolor,
                                size: 15,
                              )
                            ],
                            Text(
                              " ${widget.comment.createdAt ?? ""}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ]),
                          const SizedBox(height: 5),
                          Text(
                            widget.comment.cmntsMsg ?? "",
                            style: const TextStyle(fontSize: 14),
                          ),
                          if (widget.comment.image?.trim().isNotEmpty ?? false) ...[
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    analytics.logEvent(name: "image_popup");
                                    return Dialog.fullscreen(
                                      child: Column(
                                        children: [
                                          AppBar(
                                            title: Text("image"),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: CachedNetworkImage(imageUrl: widget.comment.image ?? ""),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(imageUrl: widget.comment.image ?? ""),
                              ),
                            )
                          ],
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.reply,
                                size: 15,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text.rich(
                                TextSpan(children: [
                                  TextSpan(
                                      text: "${widget.comment.replies?.isNotEmpty ?? false ? widget.comment.replies?.length ?? "" : ""} Reply",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          commentEditPopup(
                                            context: context,
                                            isCommentEdit: false,
                                            comment: widget.comment,
                                            communityId: widget.communityId,
                                          );
                                        }),
                                  if (widget.comment.replies?.isNotEmpty ?? false)
                                    TextSpan(
                                        text: "| ${isOpenedReply ? "Hide" : "Show"}",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            safeSetState(() => isOpenedReply = !isOpenedReply);
                                          }),
                                ]),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                      child: PopupMenuButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.more_vert,
                          size: 30,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        itemBuilder: (context) => [
                          if (widget.comment.isMyComment ?? false) ...[
                            PopupMenuItem(
                              value: 1,
                              textStyle: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.buttoncolor,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Edit",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              textStyle: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.buttoncolor,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline_rounded,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Delete",
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (!(widget.comment.isMyComment ?? false))
                            PopupMenuItem(
                                value: 3,
                                textStyle: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.buttoncolor,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.report_outlined,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      "Report",
                                    ),
                                  ],
                                )),
                        ],
                        onSelected: (value) {
                          if (value == 1) {
                            commentEditPopup(
                              context: context,
                              isCommentEdit: true,
                              comment: widget.comment,
                              communityId: widget.communityId,
                            );
                          } else if (value == 2) {
                            deleteCommentAndReplyPopup(
                                context: context,
                                callback: () {
                                  context.read<BatchCommunityBloc>().add(DeleteCommunityComment(
                                        commentId: widget.comment.commentId ?? "",
                                        communityId: widget.communityId,
                                      ));
                                });
                          } else if (value == 3) {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                enableDrag: true,
                                showDragHandle: true,
                                builder: (context) => CommunityReportPopup(
                                      typeOfCommunity: TypeOfCommunity.comment,
                                      id: widget.comment.commentId ?? "",
                                    ));
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        if (isOpenedReply)
          ListView.separated(
            padding: EdgeInsets.only(
              left: 50,
              top: 10,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              Reply reply = widget.comment.replies![index];
              return Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(
                      reply.user?.profilePhoto ?? "",
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
                                      "${reply.user?.name ?? ""}.",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (reply.user?.isVerified ?? false) ...[
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.verified,
                                      color: ColorResources.buttoncolor,
                                      size: 15,
                                    )
                                  ],
                                  Text(
                                    " ${reply.createdAt ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ]),
                                const SizedBox(height: 5),
                                Text(
                                  reply.cmntsMsg ?? "",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            child: PopupMenuButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.more_vert,
                                size: 30,
                                weight: 100,
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                              itemBuilder: (context) => [
                                if (reply.isMyReplyComment ?? false) ...[
                                  PopupMenuItem(
                                    value: 1,
                                    textStyle: GoogleFonts.notoSansDevanagari(
                                      color: ColorResources.buttoncolor,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          "Edit",
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    textStyle: GoogleFonts.notoSansDevanagari(
                                      color: ColorResources.buttoncolor,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete_outline_rounded,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          "Delete",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                if (!(reply.isMyReplyComment ?? false))
                                  PopupMenuItem(
                                      value: 3,
                                      textStyle: GoogleFonts.notoSansDevanagari(
                                        color: ColorResources.buttoncolor,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.report_outlined,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          const Text(
                                            "Report",
                                          ),
                                        ],
                                      )),
                              ],
                              onSelected: (value) {
                                if (value == 1) {
                                  commentEditPopup(
                                    context: context,
                                    isCommentEdit: false,
                                    comment: widget.comment,
                                    communityId: widget.communityId,
                                    reply: reply,
                                  );
                                } else if (value == 2) {
                                  deleteCommentAndReplyPopup(
                                      context: context,
                                      callback: () {
                                        context.read<BatchCommunityBloc>().add(DeleteReplyCommunityComment(
                                              commentId: widget.comment.commentId ?? "",
                                              communityId: widget.communityId,
                                              replyCommentId: reply.replyId ?? "",
                                            ));
                                      });
                                } else if (value == 3) {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      enableDrag: true,
                                      showDragHandle: true,
                                      builder: (context) => CommunityReportPopup(
                                            typeOfCommunity: TypeOfCommunity.reply,
                                            id: reply.replyId ?? "",
                                          ));
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
            itemCount: widget.comment.replies?.length ?? 0,
          )
      ],
    );
  }
}

deleteCommentAndReplyPopup({
  required BuildContext context,
  required Function callback,
}) async {
  bool result = await showDialog(
      context: context,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Are you sure you want to delete ?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorResources.textblack,
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
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
                            "No",
                            style: TextStyle(color: ColorResources.buttoncolor),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: ColorResources.buttoncolor,
                          ),
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              color: ColorResources.textWhite,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ));
  if (result == true) callback();
}

commentEditPopup({
  required BuildContext context,
  Comment? comment,
  Reply? reply,
  required bool isCommentEdit,
  required String communityId,
}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => PopupCommentEdit(
            isCommentEdit: isCommentEdit,
            communityId: communityId,
            comment: comment,
            reply: reply,
          ));
}
