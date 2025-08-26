// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/all_post_model.dart';
import 'package:sd_campus_app/features/data/remote/models/get_post_by_id.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/shimmer_custom.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/appstring.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/Community/post_detail.dart';

class CommunityFeedsScreen extends StatefulWidget {
  const CommunityFeedsScreen({super.key});

  @override
  State<CommunityFeedsScreen> createState() => _CommunityFeedsScreenState();
}

class _CommunityFeedsScreenState extends State<CommunityFeedsScreen> {
  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "feed", screenClass: "CommunityFeedsScreen");
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          analytics.logEvent(name: "feed_refresh");
          safeSetState(() {});
        },
        child: FutureBuilder(
            future: RemoteDataSourceImpl().getAllPostsRequest(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return FeedCardWidget(
                    allPostsModeldata: snapshot.data?.data ?? [],
                  );
                } else {
                  return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            }),
      ),
    );
  }
}

class FeedCardWidget extends StatefulWidget {
  final List<AllPostsModelData> allPostsModeldata;
  const FeedCardWidget({super.key, required this.allPostsModeldata});

  @override
  State<FeedCardWidget> createState() => _FeedCardWidgetState();
}

class _FeedCardWidgetState extends State<FeedCardWidget> {
  int page = 2;
  List<AllPostsModelData> allPostsModeldata = [];
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool hasMore = false;
  @override
  void initState() {
    page = 2;
    allPostsModeldata = widget.allPostsModeldata;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      hasMore = scrollController.position.maxScrollExtent > 0 ? true : false;
      scrollController.addListener(() async {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.95 && !isLoading) {
          safeSetState(() {
            isLoading = true;
          });
          if (hasMore) {
            AllPostsModel data = await RemoteDataSourceImpl().getAllPostsRequest(
              page: page,
            );
            safeSetState(() {
              allPostsModeldata.addAll(data.data ?? []);
              isLoading = false;
              page = page + 1;
              hasMore = data.data?.isNotEmpty ?? false;
            });
          }
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    page = 1;
    isLoading = false;
    hasMore = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.only(top: 10),
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        itemCount: allPostsModeldata.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) => index == allPostsModeldata.length
            ? const Center(child: CircularProgressIndicator())
            : GestureDetector(
                onTapCancel: () {
                  //print("object");
                },
                onDoubleTap: () {},
                onTap: () async {
                  Preferences.onLoading(context);
                  GetPostsByIdModel data = await RemoteDataSourceImpl().getPostsbyidRequest(id: allPostsModeldata[index].id!);
                  Preferences.hideDialog(context);
                  if (data.status ?? false) {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(
                      builder: (context) => PostDetailScreen(
                        postdetail: data,
                      ),
                    ))
                        .then((value) {
                      //print(value);
                      if (mounted) {
                        safeSetState(() {});
                      }
                    });
                  }
                },
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x7FD9D9D9),
                          blurRadius: 41,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: CachedNetworkImageProvider(allPostsModeldata[index].author!.profileIcon!),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            allPostsModeldata[index].title!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.notoSansDevanagari(
                                              color: ColorResources.textblack,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            allPostsModeldata[index].createdAt!,
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
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorResources.buttoncolor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  allPostsModeldata[index].tags?.toCapitalized() ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: allPostsModeldata[index].featuredImage!,
                            placeholder: (context, url) => Center(
                              child: ShimmerCustom.rectangular(height: 100),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                    '${allPostsModeldata[index].viewsCount} ${Preferences.appString.views}',
                                    style: GoogleFonts.notoSansDevanagari(
                                      color: ColorResources.textBlackSec,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    allPostsModeldata[index].isLiked! ? Icons.favorite : Icons.favorite_border_outlined,
                                    color: allPostsModeldata[index].isLiked! ? Colors.red : Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    allPostsModeldata[index].likeCounts!,
                                    style: GoogleFonts.notoSansDevanagari(
                                      color: ColorResources.textBlackSec,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.share,
                                  ),
                                  // const SizedBox(
                                  //   width: 5,
                                  // ),
                                  // Text(
                                  //   allPostsModeldata[index].comments!.count!,
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
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // allPostsModeldata[index].comments!.commentList!.isEmpty
                        //     ? Container()
                        //     : Column(
                        //         children: [
                        //           const Divider(),
                        //           ListView.builder(
                        //             physics:
                        //                 const NeverScrollableScrollPhysics(),
                        //             shrinkWrap: true,
                        //             itemCount: allPostsModeldata[index]
                        //                 .comments!
                        //                 .commentList!
                        //                 .length,
                        //             itemBuilder: (context, cindex) {
                        //               return Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Row(
                        //                   children: [
                        //                     CircleAvatar(
                        //                       radius: 20,
                        //                       backgroundImage:
                        //                           CachedNetworkImageProvider(
                        //                         allPostsModeldata[index]
                        //                             .comments!
                        //                             .commentList![cindex]
                        //                             .user!
                        //                             .profileIcon!,
                        //                       ),
                        //                     ),
                        //                     const SizedBox(
                        //                       width: 5,
                        //                     ),
                        //                     Expanded(
                        //                       child: Container(
                        //                         padding:
                        //                             const EdgeInsets.all(10),
                        //                         decoration: BoxDecoration(
                        //                           color:
                        //                               const Color(0x60D9D9D9),
                        //                           borderRadius:
                        //                               BorderRadius.circular(10),
                        //                         ),
                        //                         child: Column(
                        //                           crossAxisAlignment:
                        //                               CrossAxisAlignment.start,
                        //                           children: [
                        //                             Text.rich(
                        //                               TextSpan(
                        //                                 children: [
                        //                                   TextSpan(
                        //                                     text:
                        //                                         '${allPostsModeldata[index].comments!.commentList![cindex].user!.name}. ',
                        //                                     style: GoogleFonts
                        //                                         .notoSansDevanagari(
                        //                                       color:
                        //                                           ColorResources
                        //                                               .textblack,
                        //                                       fontSize: 10,
                        //                                       fontWeight:
                        //                                           FontWeight
                        //                                               .w600,
                        //                                     ),
                        //                                   ),
                        //                                   TextSpan(
                        //                                     text: allPostsModeldata[
                        //                                             index]
                        //                                         .comments!
                        //                                         .commentList![
                        //                                             cindex]
                        //                                         .createdAt,
                        //                                     style: GoogleFonts
                        //                                         .notoSansDevanagari(
                        //                                       color:
                        //                                           ColorResources
                        //                                               .textblack,
                        //                                       fontSize: 10,
                        //                                       fontWeight:
                        //                                           FontWeight
                        //                                               .w300,
                        //                                       height: 0,
                        //                                     ),
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                             ),
                        //                             Text(
                        //                               allPostsModeldata[index]
                        //                                   .comments!
                        //                                   .commentList![cindex]
                        //                                   .cmntsMsg!,
                        //                               maxLines: 3,
                        //                               overflow:
                        //                                   TextOverflow.ellipsis,
                        //                               style: GoogleFonts
                        //                                   .notoSansDevanagari(
                        //                                 color: ColorResources
                        //                                     .textblack,
                        //                                 fontSize: 10,
                        //                                 fontWeight:
                        //                                     FontWeight.w400,
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               );
                        //             },
                        //           )
                        //         ],
                        //       ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
