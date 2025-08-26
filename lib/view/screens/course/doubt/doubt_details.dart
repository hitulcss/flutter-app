import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_doubts_model.dart';
import 'package:sd_campus_app/features/presentation/bloc/batch_doubt/batch_doubt_bloc.dart';
import 'package:sd_campus_app/features/presentation/widgets/Community_report_popup.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/type_of_community.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/course/community/comments_card_widget.dart';
import 'package:sd_campus_app/view/screens/course/doubt/doubt_card.dart';
import 'package:sd_campus_app/view/screens/course/doubt/popup_doubt_comment.dart';

class DoubtPostDetailScreen extends StatefulWidget {
  final String postid;
  final String batchId;
  final bool isMyDoubt;
  const DoubtPostDetailScreen({
    super.key,
    required this.postid,
    required this.batchId,
    required this.isMyDoubt,
  });

  @override
  State<DoubtPostDetailScreen> createState() => _DoubtPostDetailScreenState();
}

class _DoubtPostDetailScreenState extends State<DoubtPostDetailScreen> {
  int page = 1;
  TextEditingController commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    analytics.logScreenView(
      screenName: 'Doubt Post Detail Screen',
      parameters: {
        'postId': widget.postid,
        'batchId': widget.batchId,
        'isMyDoubt': widget.isMyDoubt.toString(),
      },
    );
    BlocProvider.of<BatchDoubtBloc>(context).add(PostDoubtDetails(postId: widget.postid));
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Doubt'),
        actions: [
          IconButton(
            icon: Icon(Icons.report_gmailerrorred),
            onPressed: () {
              analytics.logEvent(
                name: "chat_policy",
              );
              showModalBottomSheet(
                  showDragHandle: true,
                  context: context,
                  builder: (context) => Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Chat Policy",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Divider(),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Html(
                                data: jsonDecode(Preferences.remoteNewPolicy)["chat_policy"],
                              ),
                            ),
                          )
                        ],
                      ));
            },
            tooltip: 'Policy',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<BatchDoubtBloc, BatchDoubtState>(
          builder: (context, state) {
            if (state is DoubtLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.doubt.where((element) => element.id == widget.postid).firstOrNull != null)
                      DoubtCardWidget(
                        isLocked: false,
                        doubt: state.doubt.where((element) => element.id == widget.postid).first,
                        isddetail: true,
                        batchId: widget.batchId,
                        isMyDoubt: widget.isMyDoubt,
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (state.doubt.firstWhere((element) => element.id == widget.postid, orElse: () => Doubt(comments: [])).comments?.isNotEmpty ?? false)
                      Text(
                        '${(state.doubt.where((element) => element.id == widget.postid).first.totalComments ?? 0) > 1 ? "Comments" : "Comment"} ${(state.doubt.where((element) => element.id == widget.postid).first.totalComments ?? 0) > 0 ? "${"(${state.doubt.where((element) => element.id == widget.postid).first.totalComments ?? 0}"})" : ""}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    (state.doubt.firstWhere((element) => element.id == widget.postid, orElse: () => Doubt(comments: [])).comments?.isEmpty ?? true)
                        ? SizedBox(height: 200, child: Center(child: Text("No comments yet")))
                        : ListView.separated(
                            padding: EdgeInsets.only(top: 10),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.doubt.where((element) => element.id == widget.postid).first.comments?.length ?? 0,
                            separatorBuilder: (context, index) => SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              var comment = state.doubt.where((element) => element.id == widget.postid).first.comments?[index];
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: CachedNetworkImageProvider(
                                      comment?.user?.profilePhoto ?? "",
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
                                                    "${comment?.user?.name ?? ""} ",
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  if (comment?.user?.isVerified ?? false) ...[
                                                    Icon(
                                                      Icons.verified,
                                                      color: ColorResources.buttoncolor,
                                                      size: 15,
                                                    )
                                                  ],
                                                ]),
                                                const SizedBox(height: 2),
                                                Text(
                                                  comment?.msg ?? "",
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                                if (comment?.image?.trim().isNotEmpty ?? false) ...[
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          analytics.logEvent(
                                                            name: "comment image preview",
                                                            parameters: {
                                                              'postId': widget.postid,
                                                              'batchId': widget.batchId,
                                                              'isMyDoubt': widget.isMyDoubt.toString(),
                                                              "commentId": comment?.commentId ?? "commentId",
                                                            },
                                                          );
                                                          return Dialog.fullscreen(
                                                            child: Column(
                                                              children: [
                                                                AppBar(
                                                                  title: Text("image"),
                                                                ),
                                                                Expanded(
                                                                  child: Center(
                                                                    child: CachedNetworkImage(imageUrl: comment?.image ?? ""),
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
                                                      child: CachedNetworkImage(
                                                        imageUrl: comment?.image ?? "",
                                                        height: 200,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                                SizedBox(
                                                  height: 1,
                                                ),
                                                Text(
                                                  comment?.createdAt ?? "",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: ColorResources.textBlackSec,
                                                  ),
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
                                                if (comment?.isMyComment ?? false) ...[
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
                                                if (!(comment?.isMyComment ?? false))
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
                                                  // commentEditPopup(
                                                  //   context: context,
                                                  //   isCommentEdit: true,
                                                  //   comment: widget.comment,
                                                  //   communityId: widget.communityId,
                                                  // );
                                                  showModalBottomSheet(
                                                    context: context,
                                                    showDragHandle: true,
                                                    isScrollControlled: true,
                                                    builder: (context) => PopupDoubtCommentEdit(
                                                      doubtId: widget.postid,
                                                      comment: comment,
                                                    ),
                                                  );
                                                } else if (value == 2) {
                                                  deleteCommentAndReplyPopup(
                                                      context: context,
                                                      callback: () {
                                                        RemoteDataSourceImpl().deleteBatchDoubtComment(commentId: comment?.commentId ?? "").then((value) {
                                                          if (value.status) {
                                                            context.read<BatchDoubtBloc>().add(DeleteDoubtComment(
                                                                  commentId: comment?.commentId ?? "",
                                                                  doubtId: widget.postid,
                                                                ));
                                                          }
                                                        });
                                                      });
                                                } else if (value == 3) {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    enableDrag: true,
                                                    showDragHandle: true,
                                                    builder: (context) => CommunityReportPopup(
                                                      typeOfDobut: TypeOfDobut.comment,
                                                      id: comment?.commentId ?? "",
                                                    ),
                                                  );
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
                            }),
                  ],
                ),
              );
            } else if (state is DoubtLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              // print("this is not able to happen");
              return SizedBox();
            }
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              builder: (context) => PopupDoubtCommentEdit(
                doubtId: widget.postid,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: ColorResources.buttoncolor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
                    child: Text('Write a comment'),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: ColorResources.buttoncolor,
                  child: Icon(
                    Icons.send,
                    color: ColorResources.textWhite,
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
