import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/cubit/youtubevideo_cubit/youtubevideo_cubit.dart';
import 'package:sd_campus_app/features/presentation/widgets/cus_player.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/lecture/lecture_rating.dart';
import 'package:sd_campus_app/features/presentation/widgets/lecture/lecture_report.dart';
import 'package:sd_campus_app/features/presentation/widgets/lecture/report_sugg.dart';
import 'package:sd_campus_app/features/presentation/widgets/resourcespdfwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/models/library/get_video_learning.dart';
import 'package:sd_campus_app/util/appstring.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/playertype.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:url_launcher/url_launcher.dart';

class YoutubeVideoDetailScreen extends StatefulWidget {
  final Video selectedVideo;
  final List<Video> videos;
  const YoutubeVideoDetailScreen({super.key, required this.selectedVideo, required this.videos});

  @override
  State<YoutubeVideoDetailScreen> createState() => _YoutubeVideoDetailScreenState();
}

class _YoutubeVideoDetailScreenState extends State<YoutubeVideoDetailScreen> {
  late Video selectedVideo;
  final TextEditingController _message = TextEditingController();
  List messages = [];
  @override
  void initState() {
    super.initState();
    selectedVideo = widget.selectedVideo;
    context.read<YoutubeVideoCubit>().commentget(videoid: selectedVideo.id ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          // removeTop: true,
          child: CuPlayerScreen(
            autoPLay: true,
            url: selectedVideo.url ?? "",
            isLive: false,
            playerType: PlayerType.youtube,
            wallpaper: SvgImages.noImageVideo,
            canpop: true,
            children: const [],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5),
          child: Text(selectedVideo.title ?? "", style: GoogleFonts.notoSansDevanagari(fontSize: Fontsize().h5, fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: DefaultTabController(
            length: 6,
            child: Column(children: [
              TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                tabs: [
                  Tab(
                    text: Preferences.appString.info ?? "Info",
                    icon: const Icon(
                      Icons.description_outlined,
                    ),
                  ),
                  Tab(
                    text: Preferences.appString.notes ?? "notes",
                    icon: const Icon(
                      Icons.snippet_folder_outlined,
                    ),
                  ),
                  Tab(
                    text: Preferences.appString.comments ?? "Comments",
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                    ),
                  ),
                  Tab(
                    text: "Playlist",
                    icon: const Icon(
                      Icons.subscriptions_outlined,
                    ),
                  ),
                  Tab(
                    text: Preferences.appString.rating ?? "Rating",
                    icon: const Icon(
                      Icons.star_border_rounded,
                    ),
                  ),
                  Tab(
                    text: Preferences.appString.report ?? "Report",
                    icon: const Icon(
                      Icons.warning_amber_outlined,
                    ),
                  )
                ],
              ),
              Expanded(
                child: TabBarView(children: [
                  _info(description: selectedVideo.info ?? ""),
                  _notes(notes: selectedVideo.notes ?? []),
                  commentWidget(context, selectedVideo.id ?? ""),
                  _playlist(),
                  BlocBuilder<YoutubeVideoCubit, YoutubeVideoState>(
                    builder: (context, state) {
                      return context.read<YoutubeVideoCubit>().israted
                          ? Center(child: Text(Preferences.appString.thanksForRating ?? "Thank you for rating"))
                          : LectureRatingScreen(
                              id: selectedVideo.id ?? "",
                              cubit: context.read<YoutubeVideoCubit>(),
                              isyoutube: true,
                            );
                    },
                  ),
                  BlocBuilder<YoutubeVideoCubit, YoutubeVideoState>(
                    builder: (context, state) {
                      return !context.read<YoutubeVideoCubit>().isreported
                          ? ReportSuggestionWidget(
                              cubit: context.read<YoutubeVideoCubit>(),
                            )
                          // Center(
                          //     child: Text(Preferences.appString.thanksForReporting ?? "Thank you for reporting, were trying to improve"),
                          //   )
                          : LectureReportScreen(
                              id: selectedVideo.id ?? "",
                              cubit: context.read<YoutubeVideoCubit>(),
                              isyoutube: true,
                            );
                    },
                  ),
                ]),
              )
            ]),
          ),
        )
      ],
    ));
  }

  Widget _playlist() {
    return ListView.separated(
      padding: EdgeInsets.all(10),
      itemCount: widget.videos.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          if (selectedVideo.id != widget.videos[index].id) {
            safeSetState(() {
              selectedVideo = widget.videos[index];
            });
          } else {
            flutterToast("Already Selected");
          }
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selectedVideo.id == widget.videos[index].id ? ColorResources.buttoncolor : ColorResources.borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Flexible(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FutureBuilder(
                      future: youtubeThumblineurl(videoId: widget.videos[index].url ?? ""),
                      builder: (context, snapshot) {
                        return CachedNetworkImage(
                          imageUrl: snapshot.data ?? "",
                          fit: BoxFit.fill,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => CachedNetworkImage(
                            imageUrl: SvgImages.noImageVideo,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        );
                      }),
                ),
              ),
              Flexible(
                flex: 3,
                child: Text(
                  widget.videos[index].title ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _info({required String description}) {
    return Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          left: 15.0,
          right: 15.0,
        ),
        child: Html(
          data: description,
          onAnchorTap: (url, attributes, element) {
            Uri openurl = Uri.parse(url!);
            launchUrl(
              openurl,
            );
          },
        ));
  }

  Widget _notes({required List<Note>? notes}) {
    return notes!.isEmpty
        ? Center(child: EmptyWidget(image: SvgImages.emptyresource, text: Languages.noresources))
        : Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 15.0, right: 15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Documents Shared with you'),
                  ...List.generate(
                      notes.length,
                      (index) => ResourcesContainerWidget(
                            title: notes[index].fileName ?? "",
                            uploadFile: notes[index].fileLoc ?? "",
                            resourcetype: 'pdf',
                            fileSize: notes[index].fileSize,
                          )),
                ],
              ),
            ),
          );
  }

  Widget commentWidget(BuildContext context, String videoId) {
    return BlocConsumer<YoutubeVideoCubit, YoutubeVideoState>(
      listener: (context, state) {
        switch (state) {
          case YtCommentsDeleteApiSuccess() || YtCommentsEditApiSuccess() || YtCommentsPostApiSuccess() || YtCommentsReplyApiSuccess() || YtCommentsReplyDeleteApiSuccess() || YtCommentsReportApiSuccess() || YtCommentsPinApiSuccess():
            context.read<YoutubeVideoCubit>().commentget(videoid: videoId);
            break;
          default:
            break;
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?.isEmpty ?? true
                  ? EmptyWidget(image: SvgImages.nochatEmpty, text: Preferences.appString.noComments ?? "There are no messages here yet. Start a Chat by sending a message")
                  : MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      removeBottom: true,
                      child: ListView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?.length ?? 0,
                        itemBuilder: (context, index) => Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  backgroundImage: CachedNetworkImageProvider(context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].user?.profilePhoto ?? ""),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      top: 3,
                                      bottom: 3,
                                    ),
                                    padding: const EdgeInsets.all(8),
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
                                              Text.rich(
                                                TextSpan(
                                                  text: "${context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].user?.name ?? ""} ",
                                                  children: [
                                                    TextSpan(
                                                      text: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].createdAt ?? "",
                                                      style: TextStyle(
                                                        color: ColorResources.textBlackSec,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                  style: TextStyle(
                                                    color: ColorResources.textblack,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].msg ?? ""),
                                              // SizedBox(
                                              //   height: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].isPin ?? false ? 5 : 0,
                                              // ),
                                              // context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].isPin ?? false
                                              //     ? GestureDetector(
                                              //         onTap: () {
                                              //           if (SharedPreferenceHelper.getString(Preferences.email)!.contains("@sdempire.co.in")) {
                                              //             context.read<YoutubeVideoCubit>().commentPin(commentId: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].id ?? "");
                                              //           }
                                              //         },
                                              //         child: Row(
                                              //           children: [
                                              //             Transform(
                                              //               transform: Matrix4.identity()
                                              //                 ..translate(1.5, -2.0)
                                              //                 ..rotateZ(0.80),
                                              //               child: Icon(
                                              //                 CupertinoIcons.pin,
                                              //                 color: ColorResources.buttoncolor,
                                              //                 size: 13,
                                              //               ),
                                              //             ),
                                              //             Text(
                                              //               Preferences.appString.pinned ?? 'Pinned',
                                              //               style: TextStyle(
                                              //                 color: ColorResources.buttoncolor,
                                              //                 fontSize: 10,
                                              //                 fontWeight: FontWeight.w600,
                                              //                 height: 0,
                                              //               ),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       )
                                              //     : Container(),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        threedot(
                                          index: index, isReply: false,
                                          //  isPined: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].isPin ?? false
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].replies?.isNotEmpty ?? false
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].replies?.length ?? 0,
                                        itemBuilder: (context, rindex) {
                                          return Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.white,
                                                backgroundImage: CachedNetworkImageProvider(
                                                  context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].replies?[rindex].user?.profilePhoto ?? "",
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                    top: 3,
                                                    bottom: 3,
                                                  ),
                                                  padding: const EdgeInsets.all(8),
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
                                                            Text.rich(
                                                              TextSpan(
                                                                text: "${context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].replies?[rindex].user?.name ?? ""} ",
                                                                children: [
                                                                  TextSpan(
                                                                    text: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].replies?[rindex].createdAt ?? "",
                                                                    style: TextStyle(
                                                                      color: ColorResources.textBlackSec,
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                                style: TextStyle(
                                                                  color: ColorResources.textblack,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].replies?[rindex].msg ?? "")
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      threedot(
                                                        isReply: true, index: rindex,
                                                        // isPined: false
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _message,
                onSubmitted: (value) {
                  if (_message.text.isEmpty) {
                    var snackBar = const SnackBar(
                      content: Text(
                        "Please Enter The Message",
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    context.read<YoutubeVideoCubit>().commentpost(commentText: _message.text, videoid: widget.selectedVideo.id ?? "");
                    _message.clear();
                    FocusScope.of(context).unfocus();
                    context.read<YoutubeVideoCubit>().stateupdate();
                  }
                },
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      if (_message.text.isEmpty) {
                        var snackBar = const SnackBar(content: Text("Please Enter the Message"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        context.read<YoutubeVideoCubit>().commentpost(commentText: _message.text, videoid: widget.selectedVideo.id ?? "");
                        _message.clear();
                        context.read<YoutubeVideoCubit>().stateupdate();
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: const Icon(Icons.send),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Say something...",
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget threedot({
    required int index,
    required bool isReply,
    // required bool isPined
  }) {
    return PopupMenuButton(
      color: Colors.white,
      elevation: 5,
      surfaceTintColor: Colors.white,
      icon: const Icon(
        Icons.more_vert,
        size: 20,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      itemBuilder: (context) {
        if (SharedPreferenceHelper.getString(Preferences.email)!.contains('@sdempire.co.in')) {
          return [
            PopupMenuItem(
              value: 1,
              textStyle: GoogleFonts.notoSansDevanagari(
                color: ColorResources.buttoncolor,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.red,
                  ),
                  Text(
                    Preferences.appString.delete ?? "Delete",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            if (!isReply)
              PopupMenuItem(
                value: 2,
                textStyle: GoogleFonts.notoSansDevanagari(
                  color: ColorResources.buttoncolor,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.reply_rounded),
                    Text(
                      Preferences.appString.reply ?? "Reply",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            PopupMenuItem(
              value: 3,
              textStyle: GoogleFonts.notoSansDevanagari(
                color: ColorResources.buttoncolor,
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit),
                  Text(
                    Preferences.appString.edit ?? "Edit",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // if (!isReply && !isPined)
            //   PopupMenuItem(
            //     value: 5,
            //     textStyle: GoogleFonts.notoSansDevanagari(
            //       color: ColorResources.buttoncolor,
            //     ),
            //     child: Row(
            //       children: [
            //         const Icon(CupertinoIcons.pin),
            //         Text(
            //           Preferences.appString.pin ?? "Pin",
            //           textAlign: TextAlign.center,
            //         ),
            //       ],
            //     ),
            //   ),
            // PopupMenuItem(
            //   value: 4,
            //   textStyle: GoogleFonts.notoSansDevanagari(
            //     color: ColorResources.buttoncolor,
            //   ),
            //   child: Row(
            //     children: [
            //       const Icon(
            //         Icons.report_outlined,
            //         color: Colors.redAccent,
            //       ),
            //       Text(
            //         Preferences.appString.report ?? "Report",
            //         textAlign: TextAlign.center,
            //         style: const TextStyle(
            //           color: Colors.redAccent,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ];
        } else if (SharedPreferenceHelper.getString(Preferences.userid) == context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].user?.id) {
          return [
            PopupMenuItem(
              value: 3,
              textStyle: GoogleFonts.notoSansDevanagari(
                color: ColorResources.buttoncolor,
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit),
                  Text(
                    Preferences.appString.edit ?? "Edit",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 1,
              textStyle: GoogleFonts.notoSansDevanagari(
                color: ColorResources.buttoncolor,
              ),
              child: Row(
                children: [
                  const Icon(Icons.delete_outline_outlined),
                  Text(
                    Preferences.appString.delete ?? "Delete",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            // PopupMenuItem(
            //   value: 4,
            //   textStyle: GoogleFonts.notoSansDevanagari(
            //     color: ColorResources.buttoncolor,
            //   ),
            //   child: Row(
            //     children: [
            //       const Icon(
            //         Icons.report_outlined,
            //         color: Colors.redAccent,
            //       ),
            //       Text(
            //         Preferences.appString.report ?? "Report",
            //         textAlign: TextAlign.center,
            //         style: const TextStyle(
            //           color: Colors.redAccent,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ];
        } else {
          return [
            // PopupMenuItem(
            //   value: 4,
            //   textStyle: GoogleFonts.notoSansDevanagari(
            //     color: ColorResources.buttoncolor,
            //   ),
            //   child: Row(
            //     children: [
            //       const Icon(
            //         Icons.report_outlined,
            //         color: Colors.redAccent,
            //       ),
            //       Text(
            //         Preferences.appString.report ?? "Report",
            //         textAlign: TextAlign.center,
            //         style: const TextStyle(
            //           color: Colors.redAccent,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ];
        }
      },
      onSelected: (value) {
        if (value == 1) {
          analytics.logEvent(name: "comment_delete", parameters: {
            "comment_id": context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].id ?? "",
            "comment_msg": context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].msg ?? "",
          });
          context.read<YoutubeVideoCubit>().commentDelete(commentId: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].id ?? "");
        } else if (value == 2) {
          replycomment(
            id: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].id ?? "",
            msg: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].msg ?? "",
            isReply: true,
            replyTo: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].user?.id ?? "",
          );
        } else if (value == 3) {
          _message.text = context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].msg ?? "";
          replycomment(
            id: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].id ?? "",
            msg: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].msg ?? "",
            isReply: false,
          );
        }
        // else if (value == 4) {
        //   context.read<YoutubeVideoCubit>().commentReport(commentId: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].id ?? "");
        // } else if (value == 5) {
        //   context.read<YoutubeVideoCubit>().commentPin(commentId: context.read<YoutubeVideoCubit>().getrecordedvideocomments.data?[index].id ?? "");
        // }
      },
    );
  }

  void replycomment({
    required String id,
    required String msg,
    required bool isReply,
    String? replyTo,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15.0),
              child: Text(
                isReply ? Preferences.appString.reply ?? 'Reply' : "Edit",
                style: TextStyle(
                  color: ColorResources.textblack,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                msg,
                style: TextStyle(
                  color: ColorResources.textBlackSec,
                  fontSize: 12,
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(SharedPreferenceHelper.getString(Preferences.profileImage)!),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _message,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        hintText: Preferences.appString.saysomething ?? "Say Somthing...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton.filled(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (isReply) {
                        context.read<YoutubeVideoCubit>().commentReply(replyTo: replyTo ?? "", commentText: _message.text, videoid: widget.selectedVideo.id ?? "", commentid: id);
                      } else {
                        context.read<YoutubeVideoCubit>().commentEdit(commentText: _message.text, commentId: id, videoId: widget.selectedVideo.id ?? "");
                      }
                      _message.clear();
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: ColorResources.buttoncolor,
                    ),
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ).then((value) {
      _message.clear();
    });
  }
}
