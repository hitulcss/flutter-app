import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/Community_report_popup.dart';
import 'package:sd_campus_app/features/presentation/widgets/expandable_text_widget.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/short_type.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/comment_short.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/profile_reel.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/saved_reels.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/video_controller.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/video_player_widget.dart';
import 'package:share_plus/share_plus.dart';

class VideoReelWidget extends StatefulWidget {
  ShortData shortData;
  VideoControllerManager? controllerManager = VideoControllerManager();
  VideoReelWidget({super.key, required this.shortData, this.controllerManager});

  @override
  State<VideoReelWidget> createState() => _VideoReelWidgetState();
}

class _VideoReelWidgetState extends State<VideoReelWidget> {
  ShortData? shortData;
  bool isLiked = false;
  final List<Shadow> shadow = [
    Shadow(color: ColorResources.gray, blurRadius: 5.0, offset: Offset(1, 1))
  ];
  @override
  void initState() {
    super.initState();
    shortData = widget.shortData;
    isLiked = widget.shortData.short.isLiked ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        shortData?.videoPlayerController == null && (shortData?.videoPlayerController?.value.hasError ?? true) ? Text("No Video") : VideoPlayerWidget(videoPlayerController: shortData!.videoPlayerController!),
        Positioned(
          bottom: 20,
          left: 20,
          right: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        shortData?.videoPlayerController?.pause();
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => ProfileReelScreen(
                            channelId: shortData?.short.channel?.id ?? '',
                          ),
                        ))
                            .then((data) {
                          shortData?.videoPlayerController?.play();
                        });
                      },
                      child: Row(
                        children: [
                          if (shortData?.short.channel?.profile?.isNotEmpty ?? false)
                            Hero(
                              tag: "profile-reel-screen",
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(shortData?.short.channel?.profile ?? SvgImages.aboutLogo),
                              ),
                            ),
                          SizedBox(width: 8),
                          Text(
                            shortData?.short.channel?.name ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              shadows: shadow,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    DetailedExpandableText(
                      text: shortData?.short.title ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        shadows: shadow,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      analytics.logEvent(name: "LikeShort", parameters: {
                        "shortId": shortData?.short.id ?? ""
                      });
                      RemoteDataSourceImpl().postLikeShort(shortId: shortData?.short.id ?? "").then((value) {
                        if (value && mounted) {
                          safeSetState(() {
                            shortData?.short.isLiked = !(shortData?.short.isLiked ?? false);
                            shortData?.short.likes = (shortData?.short.isLiked ?? false) ? (shortData?.short.likes ?? 0) + 1 : (shortData?.short.likes ?? 0) - 1;
                            widget.controllerManager?.shortdata[widget.shortData.index].isLiked = (shortData?.short.isLiked ?? false);
                            widget.controllerManager?.shortdata[widget.shortData.index].likes = (shortData?.short.likes ?? 0);
                          });
                        }
                      }).onError(
                        (error, stackTrace) {
                          analytics.logEvent(name: "LikeShortError", parameters: {
                            "shortId": shortData?.short.id ?? ""
                          });
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Icon(
                          (shortData?.short.isLiked ?? false) ? Icons.favorite : Icons.favorite_border,
                          color: (shortData?.short.isLiked ?? false) ? Colors.red : Colors.white,
                          shadows: shadow,
                          size: 30,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(((shortData?.short.likes ?? 0) == 0) ? "Likes" : shortData!.short.likes.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              shadows: shadow,
                            )),
                      ],
                    ),
                  ),
                  if (Preferences.newFeatures.quickLearningComment ?? false) ...[
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          // enableDrag: true,
                          isScrollControlled: true,
                          // showDragHandle: true,
                          context: context,
                          builder: (context) => CommentShortWidget(
                            shortId: shortData?.short.id ?? "",
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Iconify(
                            Uil.comment,
                            color: Colors.white,
                            // shadows: shadow,
                            size: 30,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            ((shortData?.short.commentCounts ?? 0) == 0) ? "0" : shortData!.short.commentCounts.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              shadows: shadow,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        analytics.logEvent(name: "ShareShort", parameters: {
                          "shortId": shortData?.short.id ?? ""
                        });
                        Share.share("${shortData?.short.shareLink?.text ?? ""} ${shortData?.short.shareLink?.link ?? ""}");
                      },
                      child: Column(children: [
                        Iconify(
                          '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" aria-hidden="true" role="img" class="iconify iconify--majesticons" width="1em" height="1em" preserveAspectRatio="xMidYMid meet" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m20 12l-6.4-7v3.5C10.4 8.5 4 10.6 4 19c0-1.167 1.92-3.5 9.6-3.5V19z"></path></svg>',
                          color: Colors.white,
                          // shadows: shadow,
                          size: 30,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Share",
                          style: TextStyle(
                            color: Colors.white,
                            shadows: shadow,
                          ),
                        ),
                      ])),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        analytics.logEvent(name: "SaveShort", parameters: {
                          "shortId": shortData?.short.id ?? ""
                        });
                        RemoteDataSourceImpl().postSaveShort(shortId: shortData?.short.id ?? "").then((value) {
                          if (value && mounted) {
                            safeSetState(() {
                              shortData?.short.isSaved = !(shortData?.short.isSaved ?? false);
                              widget.controllerManager?.shortdata[widget.shortData.index].isSaved = (shortData?.short.isSaved ?? false);
                            });
                          }
                        });
                      },
                      child: Column(children: [
                        Icon(
                          shortData?.short.isSaved ?? false ? Icons.bookmark_added_rounded : Icons.bookmark_outline,
                          color: Colors.white,
                          shadows: shadow,
                          size: 30,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          shortData?.short.isSaved ?? false ? "Saved" : "Save",
                          style: TextStyle(
                            color: Colors.white,
                            shadows: shadow,
                          ),
                        ),
                      ])),
                  SizedBox(
                    height: 10,
                  ),
                  PopupMenuButton(
                    iconColor: Colors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              Icon(
                                Icons.bookmark_outline,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Saved",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          )),
                      PopupMenuItem(
                          value: 2,
                          child: Row(
                            children: [
                              Icon(
                                Icons.report_outlined,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Report",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          )),
                      PopupMenuItem(
                          value: 3,
                          child: Row(
                            children: [
                              Icon(
                                Icons.policy_outlined,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Chat Policy",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ))
                    ],
                    onSelected: (value) {
                      if (value == 1) {
                        shortData?.videoPlayerController?.pause();
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => SavedReelsScreen(),
                        ))
                            .then((value) {
                          shortData?.videoPlayerController?.play();
                        });
                      } else if (value == 2) {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            enableDrag: true,
                            showDragHandle: true,
                            builder: (context) => CommunityReportPopup(
                                  typeOfShort: ShortType.feed,
                                  id: shortData?.short.id ?? "",
                                ));
                      } else if (value == 3) {
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
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
        // Positioned(
        //   bottom: 20,
        //   right: 20,
        //   child: IconButton(
        //     icon: Icon(Icons.comment, color: Colors.white),
        //     onPressed: () {
        //       // Handle comments view
        //     },
        //   ),
        // ),
      ],
    );
  }
}
