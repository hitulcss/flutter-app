import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/models/shorts/get_short_comment.dart';
import 'package:sd_campus_app/features/presentation/widgets/Community_report_popup.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/short_type.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';

class ShortCommentCardWidget extends StatefulWidget {
  final String shortId;
  final ShortComment comment;
  final Function() onReply;
  final Function() onEditComment;
  final Function(ShortCommentReply reply) onEditReply;
  final Function() onDeleteComment;
  final Function(ShortCommentReply reply) onDeleteReply;
  const ShortCommentCardWidget({super.key, required this.comment, required this.shortId, required this.onReply, required this.onEditComment, required this.onDeleteComment, required this.onDeleteReply, required this.onEditReply});

  @override
  State<ShortCommentCardWidget> createState() => _ShortCommentCardWidgetState();
}

class _ShortCommentCardWidgetState extends State<ShortCommentCardWidget> {
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
                  border: Border.all(color: ColorResources.borderColor),
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
                            widget.comment.msg ?? "",
                            style: const TextStyle(fontSize: 14),
                          ),
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
                                  TextSpan(text: "${widget.comment.replies?.isNotEmpty ?? false ? widget.comment.replies?.length ?? "" : ""} Reply", recognizer: TapGestureRecognizer()..onTap = widget.onReply
                                      //  () {
                                      // commentEditPopup(
                                      //   context: context,
                                      //   isCommentEdit: false,
                                      //   comment: widget.comment,
                                      //   communityId: widget.shortId,
                                      // );
                                      // }
                                      ),
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
                        color: Colors.white,
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
                            widget.onEditComment.call();
                          } else if (value == 2) {
                            widget.onDeleteComment.call();
                          } else if (value == 3) {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                enableDrag: true,
                                showDragHandle: true,
                                builder: (context) => CommunityReportPopup(
                                      typeOfShort: ShortType.shortComment,
                                      id: widget.comment.id ?? "",
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
              ShortCommentReply reply = widget.comment.replies![index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  reply.msg ?? "",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            child: PopupMenuButton(
                              color: Colors.white,
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
                                if (reply.isMyReply ?? false) ...[
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
                                if (!(reply.isMyReply ?? false))
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
                                  widget.onEditReply(reply);
                                } else if (value == 2) {
                                  widget.onDeleteReply(reply);
                                } else if (value == 3) {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      enableDrag: true,
                                      showDragHandle: true,
                                      builder: (context) => CommunityReportPopup(
                                            typeOfShort: ShortType.shortCommentReply,
                                            id: reply.id ?? "",
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
