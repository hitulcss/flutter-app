import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_community_model.dart';
import 'package:sd_campus_app/features/presentation/bloc/batch_community/batch_community_bloc.dart';
import 'package:sd_campus_app/features/presentation/widgets/Community_report_popup.dart';
import 'package:sd_campus_app/features/presentation/widgets/expandable_text_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/type_of_community.dart';
import 'package:sd_campus_app/view/screens/course/community/comments_card_widget.dart';
import 'package:sd_campus_app/view/screens/course/community/community_post_detail.dart';
import 'package:sd_campus_app/view/screens/course/community/community_tab.dart';

class CommunityCardWidget extends StatelessWidget {
  final bool isddetail;
  final Community post;
  final String? batchId;
  final bool isLocked;
  final bool isMyCommunity;
  const CommunityCardWidget({
    super.key,
    required this.post,
    this.isddetail = false,
    this.batchId,
    required this.isLocked,
    required this.isMyCommunity,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked
          ? () {
              flutterToast("This Content is Locked");
            }
          : isddetail
              ? null
              : () => Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => CommunityPostDetailScreen(
                        postid: post.id ?? "",
                        batchId: batchId ?? "",
                        isMyCommunity: isMyCommunity,
                      ),
                    ),
                  ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              spreadRadius: 0,
              blurRadius: 2,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: CachedNetworkImageProvider(post.user?.profilePhoto ?? ""),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    post.user?.name ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: ColorResources.textblack),
                                  ),
                                ),
                                if (post.user?.isVerified ?? false) ...[
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.verified,
                                    color: ColorResources.buttoncolor,
                                    size: 15,
                                  )
                                ],
                              ],
                            ),
                            Text(
                              post.createdAt ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: ColorResources.textBlackSec),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton(
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
                          if (post.isMyCommunity ?? false) ...[
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
                          if (!(post.isMyCommunity ?? true))
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
                          if (isLocked) {
                            flutterToast("This Content is Locked");
                          } else {
                            if (value == 1) {
                              postCommunity(batchId: batchId, context: context, community: post, isMyCommunity: isMyCommunity);
                            } else if (value == 2) {
                              deleteCommentAndReplyPopup(
                                  context: context,
                                  callback: () {
                                    context.read<BatchCommunityBloc>().add(DeleteCommunity(
                                          communityId: post.id ?? "",
                                        ));
                                    if (context.mounted && isddetail) {
                                      Navigator.pop(context);
                                    }
                                  });
                            } else if (value == 3) {
                              // report post
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  showDragHandle: true,
                                  builder: (context) => CommunityReportPopup(
                                        typeOfCommunity: TypeOfCommunity.community,
                                        id: post.id ?? "",
                                      ));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 50,
                      minWidth: double.infinity,
                      // maxHeight: isddetail ? 100 : double.infinity,
                    ),
                    // alignment: Alignment.top,
                    child: DetailedExpandableText(
                      text: (post.desc ?? ""),
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorResources.textblack,
                      ),
                    ),
                  ),
                  if (post.problemImage?.trim().isNotEmpty ?? false) ...[
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog.fullscreen(
                            child: Column(
                              children: [
                                AppBar(
                                  leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                                  title: Text(
                                    "Image Preview",
                                  ),
                                ),
                                Expanded(
                                  child: InteractiveViewer(
                                    child: Image.network(
                                      post.problemImage ?? "",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          post.problemImage ?? "",
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (isLocked) {
                              flutterToast("This Content is Locked");
                            } else {
                              context.read<BatchCommunityBloc>().add(
                                    LikeCommunity(
                                      communitiesId: post.id ?? "",
                                      isLiked: !(post.isLiked ?? false),
                                    ),
                                  );
                            }
                          },
                          child: Row(
                            children: [
                              Icon(
                                post.isLiked ?? false ? Icons.favorite : Icons.favorite_border,
                                color: post.isLiked ?? false ? ColorResources.buttoncolor : ColorResources.gray,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                (post.likes ?? 0) != 0 ? post.likes?.toString() ?? "Like" : "Like",
                                style: TextStyle(color: ColorResources.textBlackSec),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          color: ColorResources.gray,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          (post.views ?? 0) != 0 ? post.views?.toString() ?? "View" : "View",
                          style: TextStyle(
                            color: ColorResources.textBlackSec,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: (post.commentCounts ?? 0) > 0 ? MainAxisAlignment.end : MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          color: ColorResources.gray,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          (post.commentCounts ?? 0) != 0 ? post.commentCounts?.toString() ?? "Comments" : "Comments",
                          style: TextStyle(color: ColorResources.textBlackSec),
                        ),
                      ],
                    ),
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
