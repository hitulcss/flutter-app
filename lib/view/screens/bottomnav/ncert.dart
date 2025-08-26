import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sd_campus_app/features/data/remote/models/video_model.dart';
import 'package:sd_campus_app/features/presentation/bloc/api_bloc/api_bloc.dart';
import 'package:sd_campus_app/features/presentation/widgets/cus_player.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/enum/playertype.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/util/youtube_link_parser.dart';
import 'package:sd_campus_app/view/screens/bottomnav/youtube_playlist.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NcertScreen extends StatefulWidget {
  final String? from;
  const NcertScreen({super.key, this.from});

  @override
  State<NcertScreen> createState() => _NcertScreenState();
}

class _NcertScreenState extends State<NcertScreen> {
  @override
  void initState() {
    context.read<ApiBloc>().add(GetYouTubeVideo());
    analytics.logEvent(name: "app_${widget.from == 'live' ? 'live' : 'youtube'}", parameters: {
      "id": SharedPreferenceHelper.getString(Preferences.enrollId) ?? analytics.getSessionId().toString(),
      "name": SharedPreferenceHelper.getString(Preferences.name) ?? "Unknown",
      "date": DateTime.now().toString(),
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorResources.textblack),
        backgroundColor: Colors.white,
        title: Text(
          widget.from == 'live' ? 'Daily Live' : Languages.youtubevideo,
          style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
        ),
      ),
      body: BlocBuilder<ApiBloc, ApiState>(
        builder: (context, state) {
          if (state is ApiError) {
            return Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.6, width: MediaQuery.of(context).size.width * 0.8, child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"))
                //Text('Pls Refresh (or) Reopen App'),
                );
          }
          if (state is ApiYoutubeVideoSuccess) {
            return state.videoList.isEmpty
                ? Center(
                    child: EmptyWidget(
                      image: SvgImages.emptyvideo,
                      text: Languages.novideo,
                    ),
                  )
                : _bodyWidget(state.videoList);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  SingleChildScrollView _bodyWidget(List<VideoDataModel> videData) {
    List<VideoDataModel> today = [];
    for (var element in videData) {
      if (DateFormat('dd-MM-yyyy').parse(element.createdAt).toString().split(' ')[0] == DateTime.now().toString().split(' ')[0]) {
        today.add(element);
      }
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   child: Text(
          //     'Courses',
          //     style: GoogleFonts.notoSansDevanagari(fontSize: 24),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: widget.from == 'live' && today.isEmpty
                ? SizedBox(
                    height: 400,
                    child: Center(
                      child: EmptyWidget(
                        image: SvgImages.emptyvideo,
                        text: Languages.novideo,
                      ),
                    ),
                  )
                : AlignedGridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.from == 'live' ? today.length : videData.length,
                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => YoutubePlaylistScreen(
                                videData: widget.from == 'live' ? today : videData,
                                index: index,
                                from: widget.from,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: ColorResources.borderColor,
                                blurRadius: 5,
                              )
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              YouTubeContainerWidget(
                                videoUrl: widget.from == 'live' ? today[index].videoUrl : videData[index].videoUrl,
                                height: 125,
                                istapable: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => YoutubePlaylistScreen(
                                        videData: widget.from == 'live' ? today : videData,
                                        index: index,
                                        from: widget.from,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.from == 'live' ? today[index].title : videData[index].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
          )
        ],
      ),
    );
  }
}

class YouTubeContainerWidget extends StatefulWidget {
  final String videoUrl;
  final double height;
  final void Function()? istapable;
  const YouTubeContainerWidget({super.key, required this.videoUrl, required this.height, this.istapable});
  @override
  State<YouTubeContainerWidget> createState() => _YouTubeContainerWidgetState();
}

class _YouTubeContainerWidgetState extends State<YouTubeContainerWidget> {
  String videoId = '';
  String image = "";
  @override
  void initState() {
    videoId = YoutubePlayer.convertUrlToId(extractYouTubeVideolink(widget.videoUrl) ?? "") ?? '';
    youtubeThumblineurl(videoId: videoId).then((value) {
      if (mounted) {
        safeSetState(() {
          image = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.istapable ??
          () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CuPlayerScreen(
                      url: widget.videoUrl,
                      isLive: false,
                      playerType: PlayerType.youtube,
                      // wallpaper: YoutubePlayer.getThumbnail(videoId: videoId, webp: false) ,
                      canpop: false,
                      autoPLay: true,
                      children: const [],
                    )),
              ),
            );
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => PodPlayerScreen(
            //             youtubeUrl: extractYouTubeVideolink(widget.videoUrl) ?? "",
            //             isWidget: false,
            //           )
            //       //  YoutubePlayerWidget(
            //       //   videoId: videoId,
            //       // ),
            //       ),
            // );
          },
      child: Column(
        children: [
          Container(
            height: widget.height,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorResources.gray,
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  image.isEmpty ? SvgImages.aboutLogo : image,
                  // YoutubePlayer.getThumbnail(videoId: videoId, webp: false),
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Icon(
              Icons.play_circle_fill_rounded,
              color: ColorResources.textWhite,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
