import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_comments_post_id.dart' as get_comments_postid;
import 'package:sd_campus_app/features/data/remote/models/get_post_by_id.dart';
import 'package:sd_campus_app/features/presentation/widgets/shimmer_custom.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailScreen extends StatefulWidget {
  final GetPostsByIdModel postdetail;
  const PostDetailScreen({super.key, required this.postdetail});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  GetPostsByIdModel? postdetails;

  TextEditingController commentTextController = TextEditingController();
  TextEditingController replyCommentTextController = TextEditingController();

  bool islike = false;

  int count = 0;
  bool isLoading = false;
  bool hasMore = true;
  int page = 1;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    analytics.logEvent(
      name: "feed_detail",
    );
    islike = widget.postdetail.data!.isLiked!;
    postdetails = widget.postdetail;
    postdetails?.data?.comments?.commentList?.clear();
    hasMore = int.parse(postdetails?.data?.comments?.count ?? "0") != 0 ? true : false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Preferences.awareApp["isActive"] && (widget.postdetail.data?.isCommentAllowed ?? false)) {
        Preferences.awarenessPopup(context);
      }
      scrollController.addListener(() async {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.95 && !isLoading) {
          safeSetState(() {
            isLoading = true;
          });
          if (hasMore) {
            get_comments_postid.GetCommentByPostIdModel data = await RemoteDataSourceImpl().getCommentByPostIdRequest(
              id: postdetails!.data!.id ?? "",
              page: page,
            );
            safeSetState(() {
              postdetails!.data!.comments!.commentList!.addAll(
                data.data!.comments!.commentList!,
              );
              isLoading = false;
              page = page + 1;
              hasMore = data.data?.comments?.commentList?.isNotEmpty ?? false;
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    replyCommentTextController.dispose();
    commentTextController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(postdetails!.data!.title ?? ""),
          actions: [
            if (postdetails?.data?.shareUrl?.link != null && (postdetails?.data?.shareUrl?.link?.isNotEmpty ?? false))
              IconButton(
                  onPressed: () {
                    try {
                      Share.share("${postdetails?.data?.shareUrl?.text ?? ""}\n${postdetails?.data?.shareUrl?.link ?? ""}");
                    } catch (e) {
                      // print(e);
                    }
                  },
                  icon: const Icon(
                    Icons.share,
                  ))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            analytics.logEvent(name: "feed_detail_refresh", parameters: {
              "feed_name": postdetails!.data!.title!
            });
            await RemoteDataSourceImpl().getPostsbyidRequest(id: postdetails?.data?.id ?? "").then((value) {
              safeSetState(() {
                postdetails = value;
              });
            });
          },
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: postdetails!.data!.featuredImage!,
                        placeholder: (context, url) => Center(
                          child: ShimmerCustom.rectangular(height: 100),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              postdetails!.data!.title!,
                              style: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.textblack,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: CachedNetworkImageProvider(
                                    postdetails!.data!.author!.profileIcon!,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            postdetails!.data!.author!.name!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.notoSansDevanagari(
                                              color: ColorResources.textblack,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.verified,
                                            size: 15,
                                            color: ColorResources.buttoncolor,
                                          )
                                        ],
                                      ),
                                      Text(
                                        postdetails!.data!.createdAt!,
                                        style: GoogleFonts.notoSansDevanagari(
                                          color: ColorResources.textBlackSec,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Html(
                              data: postdetails!.data!.description!,
                              onAnchorTap: (url, attributes, element) {
                                Uri openurl = Uri.parse(url!);
                                launchUrl(
                                  openurl,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.remove_red_eye_outlined,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${postdetails!.data!.viewsCount!} ${Preferences.appString.views}',
                                  style: GoogleFonts.notoSansDevanagari(
                                    color: ColorResources.textBlackSec,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                analytics.logEvent(name: "feed_like", parameters: {
                                  "feed_name": postdetails!.data!.title!,
                                });
                                safeSetState(() {
                                  islike = islike ? false : true;
                                  islike ? count++ : count--;
                                });
                                // print(count);
                                RemoteDataSourceImpl().postLikeRequest(postId: postdetails!.data!.id!);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    islike ? Icons.favorite : Icons.favorite_border_outlined,
                                    color: islike ? Colors.red : Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    (int.parse(postdetails!.data!.likeCounts!) + count).toString(),
                                    style: GoogleFonts.notoSansDevanagari(
                                      color: ColorResources.textBlackSec,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    try {
                                      Share.share("${postdetails?.data?.shareUrl?.text ?? ""}\n ${postdetails?.data?.shareUrl?.link ?? ""}");
                                    } catch (e) {
                                      // print(e);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.share,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                // Text(
                                //   postdetails!.data!.comments!.count!,
                                //   style: GoogleFonts.notoSansDevanagari(
                                //     color: ColorResources.textBlackSec,
                                //     fontSize: 12,
                                //     fontWeight: FontWeight.w400,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         '${Preferences.appString.comments}(${postdetails!.data!.comments!.count})',
                      //         style: GoogleFonts.notoSansDevanagari(
                      //           color: ColorResources.textblack,
                      //           fontSize: 10,
                      //           fontWeight: FontWeight.w600,
                      //           height: 0,
                      //         ),
                      //       ),
                      //       const SizedBox(
                      //         height: 10,
                      //       ),
                      //       postdetails!.data!.comments!.commentList!.isEmpty
                      //           ? SizedBox(
                      //               height: 200,
                      //               child: Center(
                      //                 child: EmptyWidget(image: SvgImages.nochatEmpty, text: Preferences.appString.noComments ?? "No Comments"),
                      //               ),
                      //             )
                      //           : ListView.separated(
                      //               physics: const NeverScrollableScrollPhysics(),
                      //               shrinkWrap: true,
                      //               itemCount: postdetails!.data!.comments!.commentList!.length + (hasMore ? 1 : 0),
                      //               itemBuilder: (context, index) => index == postdetails!.data!.comments!.commentList!.length
                      //                   ? const Center(
                      //                       child: CircularProgressIndicator(),
                      //                     )
                      //                   : Row(
                      //                       crossAxisAlignment: CrossAxisAlignment.start,
                      //                       children: [
                      //                         CircleAvatar(
                      //                           radius: 20,
                      //                           backgroundImage: CachedNetworkImageProvider(postdetails!.data!.comments!.commentList![index].user!.profileIcon!),
                      //                         ),
                      //                         const SizedBox(
                      //                           width: 5,
                      //                         ),
                      //                         Expanded(
                      //                           child: Column(
                      //                             children: [
                      //                               Container(
                      //                                 width: double.infinity,
                      //                                 padding: const EdgeInsets.all(10),
                      //                                 decoration: BoxDecoration(
                      //                                   color: Colors.white,
                      //                                   borderRadius: BorderRadius.circular(10),
                      //                                 ),
                      //                                 child: Row(
                      //                                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                                   children: [
                      //                                     Expanded(
                      //                                       child: Column(
                      //                                         crossAxisAlignment: CrossAxisAlignment.start,
                      //                                         children: [
                      //                                           Text.rich(
                      //                                             TextSpan(
                      //                                               children: [
                      //                                                 TextSpan(
                      //                                                   text: '${postdetails!.data!.comments!.commentList![index].user!.name}. ',
                      //                                                   style: GoogleFonts.notoSansDevanagari(
                      //                                                     color: ColorResources.textblack,
                      //                                                     fontSize: 10,
                      //                                                     fontWeight: FontWeight.w600,
                      //                                                   ),
                      //                                                 ),
                      //                                                 TextSpan(
                      //                                                   text: postdetails!.data!.comments!.commentList![index].createdAt,
                      //                                                   style: GoogleFonts.notoSansDevanagari(
                      //                                                     color: ColorResources.textblack,
                      //                                                     fontSize: 10,
                      //                                                     fontWeight: FontWeight.w400,
                      //                                                   ),
                      //                                                 ),
                      //                                               ],
                      //                                             ),
                      //                                           ),
                      //                                           Text(
                      //                                             postdetails!.data!.comments!.commentList![index].cmntsMsg!,
                      //                                             style: GoogleFonts.notoSansDevanagari(
                      //                                               color: Colors.black,
                      //                                               fontSize: 12,
                      //                                               fontWeight: FontWeight.w400,
                      //                                             ),
                      //                                           ),
                      //                                           Padding(
                      //                                             padding: const EdgeInsets.symmetric(
                      //                                               vertical: 5.0,
                      //                                             ),
                      //                                             child: Row(
                      //                                               children: [
                      //                                                 Text(
                      //                                                   '${postdetails!.data!.comments?.commentList?[index].replies?.length ?? 0} Reply     ',
                      //                                                   style: GoogleFonts.notoSansDevanagari(
                      //                                                     color: ColorResources.textblack,
                      //                                                     fontSize: 10,
                      //                                                     fontWeight: FontWeight.w400,
                      //                                                     height: 0,
                      //                                                   ),
                      //                                                 ),
                      //                                                 if (postdetails?.data?.comments?.commentList?[index].isPin ?? false)
                      //                                                   Transform(
                      //                                                     transform: Matrix4.identity()
                      //                                                       ..translate(1.5, -2.0)
                      //                                                       ..rotateZ(0.80),
                      //                                                     child: Icon(
                      //                                                       CupertinoIcons.pin,
                      //                                                       color: ColorResources.buttoncolor,
                      //                                                       size: 13,
                      //                                                     ),
                      //                                                   ),
                      //                                                 if (postdetails!.data!.comments?.commentList?[index].isPin ?? false)
                      //                                                   GestureDetector(
                      //                                                     onTap: () {
                      //                                                       if (SharedPreferenceHelper.getString(Preferences.email)!.contains('@sdempire.co.in')) {
                      //                                                         Preferences.onLoading(context);
                      //                                                         RemoteDataSourceImpl().pinFeedRequest(commentId: postdetails!.data!.comments!.commentList![index].id!).then((value) {
                      //                                                           flutterToast(value.msg);
                      //                                                           if (value.status) {
                      //                                                             commentTextController.clear();
                      //                                                             RemoteDataSourceImpl().getPostsbyidRequest(id: postdetails!.data!.id!).then((value) {
                      //                                                               safeSetState(() {
                      //                                                                 postdetails = value;
                      //                                                               });
                      //                                                             });
                      //                                                           }
                      //                                                         });
                      //                                                         Preferences.hideDialog(context);
                      //                                                       }
                      //                                                     },
                      //                                                     child: Text(
                      //                                                       Preferences.appString.pinned ?? 'Pinned',
                      //                                                       style: TextStyle(
                      //                                                         color: ColorResources.buttoncolor,
                      //                                                         fontSize: 10,
                      //                                                         fontWeight: FontWeight.w600,
                      //                                                         height: 0,
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                               ],
                      //                                             ),
                      //                                           ),
                      //                                         ],
                      //                                       ),
                      //                                     ),
                      //                                     // postdetails!.data!.comments!.commentList![index].myComment! || SharedPreferenceHelper.getString(Preferences.email)!.contains('@sdempire.co.in')
                      //                                     // ?
                      //                                     PopupMenuButton(
                      //                                       icon: const Icon(
                      //                                         Icons.more_vert,
                      //                                         size: 20,
                      //                                       ),
                      //                                       shape: const RoundedRectangleBorder(
                      //                                         borderRadius: BorderRadius.all(
                      //                                           Radius.circular(20.0),
                      //                                         ),
                      //                                       ),
                      //                                       itemBuilder: (context) => SharedPreferenceHelper.getString(Preferences.email)!.contains('@sdempire.co.in')
                      //                                           ? [
                      //                                               PopupMenuItem(
                      //                                                 value: 1,
                      //                                                 textStyle: GoogleFonts.notoSansDevanagari(
                      //                                                   color: ColorResources.buttoncolor,
                      //                                                 ),
                      //                                                 child: Row(
                      //                                                   children: [
                      //                                                     const Icon(Icons.delete_outline),
                      //                                                     Text(
                      //                                                       Preferences.appString.delete ?? "Delete",
                      //                                                       textAlign: TextAlign.center,
                      //                                                     ),
                      //                                                   ],
                      //                                                 ),
                      //                                               ),
                      //                                               PopupMenuItem(
                      //                                                 value: 2,
                      //                                                 textStyle: GoogleFonts.notoSansDevanagari(
                      //                                                   color: ColorResources.buttoncolor,
                      //                                                 ),
                      //                                                 child: Row(
                      //                                                   children: [
                      //                                                     const Icon(Icons.reply_outlined),
                      //                                                     Text(
                      //                                                       Preferences.appString.reply ?? " Reply",
                      //                                                       textAlign: TextAlign.center,
                      //                                                     ),
                      //                                                   ],
                      //                                                 ),
                      //                                               ),
                      //                                               PopupMenuItem(
                      //                                                 value: 3,
                      //                                                 textStyle: GoogleFonts.notoSansDevanagari(
                      //                                                   color: ColorResources.buttoncolor,
                      //                                                 ),
                      //                                                 child: Row(
                      //                                                   children: [
                      //                                                     const Icon(Icons.report_outlined),
                      //                                                     Text(
                      //                                                       Preferences.appString.report ?? " Report",
                      //                                                       textAlign: TextAlign.center,
                      //                                                     ),
                      //                                                   ],
                      //                                                 ),
                      //                                               ),
                      //                                               PopupMenuItem(
                      //                                                 value: 4,
                      //                                                 textStyle: GoogleFonts.notoSansDevanagari(
                      //                                                   color: ColorResources.buttoncolor,
                      //                                                 ),
                      //                                                 child: Row(
                      //                                                   children: [
                      //                                                     const Icon(CupertinoIcons.pin),
                      //                                                     Text(
                      //                                                       Preferences.appString.pin ?? "Pin",
                      //                                                       textAlign: TextAlign.center,
                      //                                                     ),
                      //                                                   ],
                      //                                                 ),
                      //                                               ),
                      //                                             ]
                      //                                           : postdetails?.data?.comments?.commentList?[index].myComment ?? false
                      //                                               ? [
                      //                                                   PopupMenuItem(
                      //                                                     value: 1,
                      //                                                     textStyle: GoogleFonts.notoSansDevanagari(
                      //                                                       color: ColorResources.buttoncolor,
                      //                                                     ),
                      //                                                     child: Row(
                      //                                                       children: [
                      //                                                         const Icon(Icons.delete_outline),
                      //                                                         Text(
                      //                                                           Preferences.appString.delete ?? "Delete",
                      //                                                           textAlign: TextAlign.center,
                      //                                                         ),
                      //                                                       ],
                      //                                                     ),
                      //                                                   ),
                      //                                                 ]
                      //                                               : [
                      //                                                   PopupMenuItem(
                      //                                                     value: 3,
                      //                                                     textStyle: GoogleFonts.notoSansDevanagari(
                      //                                                       color: ColorResources.buttoncolor,
                      //                                                     ),
                      //                                                     child: Row(
                      //                                                       children: [
                      //                                                         const Icon(Icons.report_outlined),
                      //                                                         Text(
                      //                                                           Preferences.appString.report ?? " Report",
                      //                                                           textAlign: TextAlign.center,
                      //                                                         ),
                      //                                                       ],
                      //                                                     ),
                      //                                                   ),
                      //                                                 ],
                      //                                       onSelected: (value) {
                      //                                         if (value == 1) {
                      //                                           analytics.logEvent(name: "feed_delete", parameters: {
                      //                                             "feed_name": widget.postdetail.data!.title!,
                      //                                           });
                      //                                           Preferences.onLoading(context);
                      //                                           RemoteDataSourceImpl().deleteCommentRequest(commentId: postdetails!.data!.comments!.commentList![index].id!).then((value) {
                      //                                             flutterToast(value.msg);
                      //                                             if (value.status) {
                      //                                               commentTextController.clear();
                      //                                               RemoteDataSourceImpl().getPostsbyidRequest(id: postdetails!.data!.id!).then((value) {
                      //                                                 safeSetState(() {
                      //                                                   postdetails = value;
                      //                                                 });
                      //                                               });
                      //                                             }
                      //                                           });
                      //                                           Preferences.hideDialog(context);
                      //                                         } else if (value == 2) {
                      //                                           replycomment(
                      //                                             id: postdetails!.data!.comments!.commentList![index].id!,
                      //                                             msg: postdetails!.data!.comments!.commentList![index].cmntsMsg!,
                      //                                           );
                      //                                         } else if (value == 3) {
                      //                                           analytics.logEvent(name: "feed_report", parameters: {
                      //                                             "feed_name": widget.postdetail.data!.title!,
                      //                                           });
                      //                                           Preferences.onLoading(context);
                      //                                           RemoteDataSourceImpl().reportFeedRequest(commentId: postdetails!.data!.comments!.commentList![index].id!).then((value) {
                      //                                             flutterToast(value.msg);
                      //                                             if (value.status) {
                      //                                               commentTextController.clear();
                      //                                               RemoteDataSourceImpl().getPostsbyidRequest(id: postdetails!.data!.id!).then((value) {
                      //                                                 safeSetState(() {
                      //                                                   postdetails = value;
                      //                                                 });
                      //                                               });
                      //                                             }
                      //                                           });
                      //                                           Preferences.hideDialog(context);
                      //                                         } else if (value == 4) {
                      //                                           analytics.logEvent(name: "feed_pin", parameters: {
                      //                                             "feed_name": widget.postdetail.data!.title!,
                      //                                           });
                      //                                           Preferences.onLoading(context);
                      //                                           RemoteDataSourceImpl().pinFeedRequest(commentId: postdetails!.data!.comments!.commentList![index].id!).then((value) {
                      //                                             flutterToast(value.msg);
                      //                                             if (value.status) {
                      //                                               commentTextController.clear();
                      //                                               RemoteDataSourceImpl().getPostsbyidRequest(id: postdetails!.data!.id!).then((value) {
                      //                                                 safeSetState(() {
                      //                                                   postdetails = value;
                      //                                                 });
                      //                                               });
                      //                                             }
                      //                                           });
                      //                                           Preferences.hideDialog(context);
                      //                                         }
                      //                                       },
                      //                                     )
                      //                                     // : Container(),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                               const SizedBox(height: 5),
                      //                               ListView.separated(
                      //                                   physics: const NeverScrollableScrollPhysics(),
                      //                                   shrinkWrap: true,
                      //                                   itemBuilder: (context, rindex) => replaywidget(
                      //                                         comment: postdetails!.data!.comments!.commentList![index].replies![rindex],
                      //                                       ),
                      //                                   separatorBuilder: (context, rindex) => const SizedBox(
                      //                                         height: 5,
                      //                                       ),
                      //                                   itemCount: postdetails!.data!.comments!.commentList![index].replies!.length),
                      //                             ],
                      //                           ),
                      //                         )
                      //                       ],
                      //                     ),
                      //               separatorBuilder: (context, index) => const SizedBox(
                      //                 height: 5,
                      //               ),
                      //             ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
              // postdetails!.data!.isCommentAllowed! //?? false
              //     ? Container(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Row(
              //           children: [
              //             CircleAvatar(
              //               radius: 20,
              //               backgroundImage: CachedNetworkImageProvider(SharedPreferenceHelper.getString(Preferences.profileImage)!),
              //             ),
              //             const SizedBox(
              //               width: 5,
              //             ),
              //             Expanded(
              //               child: TextField(
              //                 controller: commentTextController,
              //                 decoration: InputDecoration(
              //                   filled: true,
              //                   fillColor: Colors.grey[50],
              //                   contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              //                   hintText: Preferences.appString.writeAComment ?? "Write a comment....",
              //                   border: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(30),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             const SizedBox(
              //               width: 5,
              //             ),
              //             IconButton.filled(
              //               onPressed: () {
              //                 analytics.logEvent(name: "feed_comment", parameters: {
              //                   "feed_name": widget.postdetail.data!.title!,
              //                 });
              //                 FocusScope.of(context).unfocus();
              //                 Preferences.onLoading(context);
              //                 RemoteDataSourceImpl().postAddCommentRequest(postId: postdetails!.data!.id!, msg: commentTextController.text).then((value) {
              //                   flutterToast(value.msg);
              //                   if (value.status) {
              //                     commentTextController.clear();
              //                     RemoteDataSourceImpl().getPostsbyidRequest(id: postdetails!.data!.id!).then((value) {
              //                       safeSetState(() {
              //                         postdetails = value;
              //                       });
              //                     });
              //                   }
              //                 });
              //                 Preferences.hideDialog(context);
              //               },
              //               style: IconButton.styleFrom(
              //                 backgroundColor: ColorResources.buttoncolor,
              //               ),
              //               icon: const Icon(Icons.send),
              //             )
              //           ],
              //         ),
              //       )
              //     :
              //      BottomAppBar(
              //         color: Colors.white,
              //         elevation: 0,
              //         child: GestureDetector(
              //           onTap: () {},
              //           child: Center(
              //             child: Text(
              //               Preferences.appString.commentsDisabledonPost ?? "Comments are disabled on this post",
              //               style: GoogleFonts.notoSansDevanagari(
              //                 fontSize: 16,
              //                 color: ColorResources.textblack,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  Widget replaywidget({
    required Replies comment,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: CachedNetworkImageProvider(comment.user!.profileIcon!),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${comment.user!.name}. ',
                              style: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.textblack,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: comment.createdAt,
                              style: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.textblack,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ParsedText(
                        text: comment.cmntsMsg!,
                        parse: [
                          MatchText(
                            type: ParsedType.URL,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                            onTap: (url) {
                              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                            },
                          ),
                          MatchText(
                            type: ParsedType.EMAIL,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                            onTap: (url) {
                              launchUrl(Uri(
                                scheme: 'mailto',
                                path: url,
                              ));
                            },
                          ),
                          MatchText(
                            type: ParsedType.PHONE,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                            onTap: (url) {
                              launchUrl(Uri.parse(
                                "tel:$url",
                              ));
                            },
                          ),
                        ],
                        style: GoogleFonts.notoSansDevanagari(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SharedPreferenceHelper.getString(Preferences.email)!.contains('@sdempire.co.in')
                    ? PopupMenuButton(
                        icon: const Icon(
                          Icons.more_vert,
                          size: 20,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            textStyle: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.buttoncolor,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.delete_outline),
                                Text(
                                  Preferences.appString.delete ?? "Delete",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 1) {
                            analytics.logEvent(name: "feed_delete", parameters: {
                              "feed_name": widget.postdetail.data!.title!,
                            });
                            Preferences.onLoading(context);
                            RemoteDataSourceImpl().deleteReplyCommentRequest(replyCommentId: comment.id!).then((value) {
                              flutterToast(value.msg);
                              if (value.status) {
                                commentTextController.clear();
                                RemoteDataSourceImpl().getPostsbyidRequest(id: postdetails!.data!.id!).then((value) {
                                  safeSetState(() {
                                    postdetails = value;
                                  });
                                });
                              }
                            });
                            Preferences.hideDialog(context);
                          }
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        )
      ],
    );
  }

  void replycomment({
    required String id,
    required String msg,
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
                Preferences.appString.reply ?? 'Reply',
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
                      controller: replyCommentTextController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        hintText: Preferences.appString.saysomething ?? "Say Something...",
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
                      analytics.logEvent(name: "feed_replay", parameters: {
                        "feed_name": widget.postdetail.data!.title!,
                      });
                      FocusScope.of(context).unfocus();
                      Preferences.onLoading(context);
                      RemoteDataSourceImpl().replyToCommentsRequest(commentId: id, msg: replyCommentTextController.text).then((value) {
                        flutterToast(value.msg);
                        if (value.status) {
                          replyCommentTextController.clear();
                          RemoteDataSourceImpl().getPostsbyidRequest(id: postdetails!.data!.id!).then((value) {
                            safeSetState(() {
                              postdetails = value;
                            });
                          });
                        }
                      });
                      Preferences.hideDialog(context);
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
    );
  }
}
