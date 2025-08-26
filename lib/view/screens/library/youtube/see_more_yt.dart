import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/presentation/widgets/cus_player.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/models/library/get_video_learning.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/view/screens/library/youtube/youtube_video_detail.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SeeMoreYtScreen extends StatelessWidget {
  final String title;
  final List<Video> videos;
  const SeeMoreYtScreen({super.key, required this.title, required this.videos});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: videos.isEmpty
            ? Center(child: EmptyWidget(image: SvgImages.dppNoteslive, text: "No Videos Found"))
            : StaggeredGrid.count(
                crossAxisCount: 2,
                children: List.generate(videos.length, (index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => YoutubeVideoDetailScreen(
                                selectedVideo: videos[index],
                                videos: videos,
                              )));
                    },
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FutureBuilder<String>(
                                  future: youtubeThumblineurl(videoId: videos[index].url ?? ""),
                                  builder: (context, snapshot) {
                                    return Skeletonizer(
                                      enabled: snapshot.connectionState == ConnectionState.waiting,
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data ?? SvgImages.aboutLogo,
                                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => Center(
                                            child: CachedNetworkImage(
                                          imageUrl: SvgImages.aboutLogo,
                                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        )),
                                        fit: BoxFit.cover,
                                        height: 130,
                                        width: 250,
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              videos[index].title ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })));
  }
}
