import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_doubts_model.dart';
import 'package:sd_campus_app/features/presentation/bloc/batch_doubt/batch_doubt_bloc.dart';
import 'package:sd_campus_app/features/presentation/widgets/Community_report_popup.dart';
import 'package:sd_campus_app/features/presentation/widgets/expandable_text_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/type_of_community.dart';
import 'package:sd_campus_app/view/screens/course/community/comments_card_widget.dart';
import 'package:sd_campus_app/view/screens/course/doubt/doubt_details.dart';
import 'package:sd_campus_app/view/screens/course/doubt/rise_a_doubt.dart';

class DoubtCardWidget extends StatelessWidget {
  final bool isddetail;
  final Doubt doubt;
  final String batchId;
  final bool isLocked;
  final bool isMyDoubt;
  const DoubtCardWidget({
    super.key,
    required this.isddetail,
    required this.doubt,
    required this.batchId,
    required this.isLocked,
    required this.isMyDoubt,
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
                      builder: (context) => DoubtPostDetailScreen(
                        postid: doubt.id ?? "",
                        batchId: batchId,
                        isMyDoubt: isMyDoubt,
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
              spreadRadius: 5,
              blurRadius: 7,
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
                        backgroundImage: CachedNetworkImageProvider(doubt.user?.profilePhoto ?? ""),
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
                                Text(
                                  doubt.user?.name ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: ColorResources.textblack),
                                ),
                                if (doubt.user?.isVerified ?? false) ...[
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.verified,
                                    color: ColorResources.buttoncolor,
                                    size: 15,
                                  )
                                ]
                              ],
                            ),
                            Text(
                              doubt.createdAt ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: ColorResources.textBlackSec),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: PopupMenuButton(
                          menuPadding: EdgeInsets.zero,
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.more_vert,
                            size: 30,
                          ),
                          itemBuilder: (context) => [
                            if (doubt.isMyDoubt ?? false) ...[
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
                            if (!(doubt.isMyDoubt ?? false))
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
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => RiseADoubtPopup(
                                          batchId: batchId,
                                          doubt: doubt,
                                          isMyDoubt: isMyDoubt,
                                        ));
                              } else if (value == 2) {
                                deleteCommentAndReplyPopup(
                                    context: context,
                                    callback: () {
                                      RemoteDataSourceImpl().deleteBatchDoubt(doubtId: doubt.id ?? "").then((value) {
                                        if (value.status) {
                                          context.read<BatchDoubtBloc>().add(DeleteDoubt(
                                                doubtId: doubt.id ?? "",
                                              ));
                                        }
                                        if (context.mounted && isddetail) {
                                          Navigator.pop(context);
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
                                          typeOfDobut: TypeOfDobut.doubt,
                                          id: doubt.id ?? "",
                                        ));
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  Text(
                    '${doubt.subject} ${doubt.lectureName?.isEmpty ?? true ? "" : "| ${doubt.lectureName}"}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ColorResources.buttoncolor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DetailedExpandableText(
                    text: doubt.desc ?? "",
                    style: TextStyle(
                      color: ColorResources.textblack,
                      fontSize: 12,
                    ),
                  ),
                  if (doubt.problemImage?.trim().isNotEmpty ?? false) ...[
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            analytics.logEvent(
                              name: "Doubt image preview",
                              parameters: {
                                'postId': doubt.id ?? "postId",
                                'batchId': batchId,
                                'isMyDoubt': isMyDoubt.toString(),
                              },
                            );
                            return Dialog.fullscreen(
                              child: Column(
                                children: [
                                  AppBar(
                                    title: Text("image"),
                                  ),
                                  Expanded(
                                    child: Image.network(
                                      doubt.problemImage ?? "",
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
                        child: Image.network(
                          doubt.problemImage ?? "",
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      analytics.logEvent(
                        name: "Doubt like",
                        parameters: {
                          'postId': doubt.id ?? "postId",
                          'batchId': batchId,
                          'isMyDoubt': isMyDoubt.toString(),
                          "islocked": isLocked.toString(),
                        },
                      );
                      if (isLocked) {
                        flutterToast("this Content is locked");
                      } else {
                        context.read<BatchDoubtBloc>().add(
                              LikeDoubt(
                                doubtId: doubt.id ?? "",
                                isLiked: !(doubt.isLiked ?? false),
                              ),
                            );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          doubt.isLiked ?? false ? Icons.favorite : Icons.favorite_border,
                          color: doubt.isLiked ?? false ? ColorResources.buttoncolor : ColorResources.gray,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          doubt.likes?.toString() ?? "0",
                          style: TextStyle(color: ColorResources.textBlackSec),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Iconify(
                        Uil.comment,
                        color: ColorResources.gray,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        doubt.totalComments == 0 ? "Comments" : doubt.totalComments?.toString() ?? "0",
                        style: TextStyle(
                          color: ColorResources.textBlackSec,
                        ),
                      ),
                    ],
                  ),
                  doubt.isResolved ?? true
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xFFC8FFCE),
                          ),
                          child: Row(
                            children: [
                              Iconify(MaterialSymbols.check_circle, color: Color(0xFF008000)),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Resolved",
                                style: TextStyle(
                                  color: Color(0xFF008000),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xFFFFBC0C),
                          ),
                          child: Row(
                            children: [
                              Iconify(MaterialSymbols.schedule, color: Colors.white),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Pending",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
