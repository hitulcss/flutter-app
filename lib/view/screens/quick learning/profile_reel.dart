import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:sd_campus_app/features/data/remote/models/shorts/get_short_video.dart';
import 'package:sd_campus_app/features/presentation/widgets/shimmer_custom.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/short_type.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/short_learning.dart';
import "package:skeletonizer/skeletonizer.dart";
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/shorts/get_short_channel.dart';
import 'package:sd_campus_app/util/extenstions/int_extenstions.dart';
import 'package:share_plus/share_plus.dart';

class ProfileReelScreen extends StatefulWidget {
  final String channelId;
  const ProfileReelScreen({super.key, required this.channelId});

  @override
  State<ProfileReelScreen> createState() => _ProfileReelScreenState();
}

class _ProfileReelScreenState extends State<ProfileReelScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Short> channelVideos = [];
  GetShortChannel? profileData;
  bool isLoading = true;
  bool isShortLoading = true;
  bool isFollowing = false;
  int _currentPage = 1;
  bool isReachedMax = true;
  @override
  void initState() {
    super.initState();
    analytics.logScreenView(
      screenName: "app_profile_reel",
      screenClass: "ProfileReelScreen",
      parameters: {
        "channel": widget.channelId,
      },
    );
    Future(() {
      getchannelProfile();
      fetchMoreData();
      _scrollController.addListener(scrollListening);
    });
  }

  void scrollListening() {
    if (!isShortLoading) {
      if (_scrollController.offset == _scrollController.position.maxScrollExtent && !isReachedMax) {
        fetchMoreData();
      }
    }
  }

  Future<void> getchannelProfile() async {
    await RemoteDataSourceImpl().getShortChannelProfile(channelId: widget.channelId).then((value) {
      if (mounted) {
        safeSetState(() {
          profileData = value;
          isLoading = false;
          _currentPage++;
          isFollowing = value.data?.isSubscribe ?? false;
        });
      }
    }).onError(
      (error, stackTrace) {
        analytics.logEvent(
          name: "fetched channel profile error",
          parameters: {
            "screen": "app_profile_reel",
            "channel": widget.channelId,
            "error": error.toString(),
            "stackTrace": stackTrace.toString(),
          },
        );
      },
    );
  }

  Future<void> fetchMoreData() async {
    analytics.logEvent(
      name: "fetchMoreData",
      parameters: {
        "screen": "app_profile_reel",
        "channel": widget.channelId,
        "page": _currentPage,
      },
    );
    await RemoteDataSourceImpl()
        .getShortVideosByChannelId(
      channelId: widget.channelId,
      page: _currentPage,
    )
        .then((value) {
      if (mounted) {
        safeSetState(() {
          channelVideos.addAll(value.data?.shorts ?? []);
          isReachedMax = channelVideos.length == (value.data?.totalCounts ?? 0);
          isShortLoading = false;
        });
      }
    }).onError(
      (error, stackTrace) {
        analytics.logEvent(
          name: "fetched channel profile error",
          parameters: {
            "screen": "app_profile_reel",
            "channel": widget.channelId,
            "error": error.toString(),
            "stackTrace": stackTrace.toString(),
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListening);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        elevation: 0,
        shadowColor: null,
        title: Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              Share.share(
                "${profileData?.data?.shareLink?.text ?? ""} ${profileData?.data?.shareLink?.link ?? ""}",
              );
            },
            icon: Icon(Icons.share),
          )
        ],
      ),
      body: Skeletonizer(
        enabled: isLoading && isShortLoading,
        ignoreContainers: false,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Hero(
                      tag: "profile-reel-screen",
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(profileData?.data?.profile ?? SvgImages.aboutLogo),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      profileData?.data?.name ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Center(
                        child: Html(
                          data: profileData?.data?.description ?? "",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: IntrinsicHeight(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              TweenAnimationBuilder<int>(
                                tween: IntTween(begin: 0, end: profileData?.data?.shortCount ?? 0),
                                duration: Duration(seconds: 2),
                                curve: Curves.linearToEaseOut,
                                builder: (context, value, child) {
                                  return Text(
                                    value.toNumberFormattedViews(),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Shorts',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          VerticalDivider(),
                          Column(
                            children: [
                              TweenAnimationBuilder<int>(
                                tween: IntTween(begin: 0, end: profileData?.data?.likeCount ?? 0),
                                duration: Duration(seconds: 2),
                                builder: (context, value, child) {
                                  return Text(
                                    value.toNumberFormattedViews(),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Likes',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          VerticalDivider(),
                          Column(
                            children: [
                              TweenAnimationBuilder<int>(
                                tween: IntTween(begin: 0, end: profileData?.data?.viewCount ?? 0),
                                duration: Duration(seconds: 2),
                                builder: (context, value, child) {
                                  return Text(
                                    value.toNumberFormattedViews(),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Views',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          VerticalDivider(),
                          Column(
                            children: [
                              TweenAnimationBuilder<int>(
                                tween: IntTween(begin: 0, end: profileData?.data?.subscriberCount ?? 0),
                                duration: Duration(seconds: 2),
                                builder: (context, value, child) {
                                  return Text(
                                    value.toNumberFormattedViews(),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Followers',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            analytics.logEvent(name: "followChannel", parameters: {
                              "screen": "app_profile_reel",
                              "channel": widget.channelId
                            });
                            RemoteDataSourceImpl().postSubscribeChannel(channelId: widget.channelId).then((value) {
                              safeSetState(() {
                                profileData?.data?.subscriberCount = value ? (profileData?.data?.subscriberCount ?? 0) + 1 : (profileData?.data?.subscriberCount ?? 0) - 1;
                                isFollowing = !isFollowing;
                              });
                            }).onError(
                              (error, stackTrace) {
                                analytics.logEvent(name: "followChannelErorr", parameters: {
                                  "screen": "app_profile_reel",
                                  "channel": widget.channelId,
                                  "error": error.toString()
                                });
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFollowing ? Colors.white : ColorResources.buttoncolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            isFollowing ? "Following" : 'Follow',
                            style: TextStyle(
                              color: isFollowing ? Colors.black : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: Colors.white,
                child: channelVideos.isEmpty
                    ? SizedBox(
                        height: 300,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                child: Icon(
                                  Icons.video_collection_outlined,
                                  size: 40,
                                  color: ColorResources.buttoncolor,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('No shorts yet!')
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        // controller: _scrollController,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.6,
                        ),
                        itemCount: channelVideos.length,
                        itemBuilder: (context, index) {
                          Short data = channelVideos[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ShortLearningScreen(
                                  shortType: ShortType.saved,
                                  shorts: channelVideos,
                                  page: _currentPage,
                                  index: index,
                                ),
                              ));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  FutureBuilder(
                                      future: VideoThumbnail.thumbnailData(
                                        video: data.urls?.first.url ?? "",
                                        imageFormat: ImageFormat.WEBP,
                                        maxHeight: 400,
                                        maxWidth: 900,
                                        quality: 20,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Image.memory(
                                            snapshot.data!,
                                            fit: BoxFit.fitWidth,
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text("error"),
                                          );
                                        } else {
                                          return ShimmerCustom.rectangular(height: double.infinity);
                                        }
                                      }),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    left: 0,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        bottom: 5,
                                        right: 10,
                                      ),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [
                                        0.05,
                                        1
                                      ], colors: [
                                        Colors.black,
                                        Colors.transparent
                                      ])),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  data.description ?? "",
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${data.views} Views',
                                                style: TextStyle(color: Colors.white, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (!isReachedMax)
                Center(
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
