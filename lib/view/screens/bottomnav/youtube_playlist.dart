import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/models/video_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/cus_player.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/playertype.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/view/screens/bottomnav/ncert.dart';

class YoutubePlaylistScreen extends StatefulWidget {
  final String? from;
  final int index;
  final List<VideoDataModel> videData;
  const YoutubePlaylistScreen({super.key, this.from, required this.videData, required this.index});

  @override
  State<YoutubePlaylistScreen> createState() => _YoutubePlaylistScreenState();
}

class _YoutubePlaylistScreenState extends State<YoutubePlaylistScreen> {
  VideoDataModel seleted = VideoDataModel(id: "", videoUrl: '', title: '', user: '', isActive: true, createdAt: '', language: '');

  @override
  void initState() {
    super.initState();
    seleted = widget.videData[widget.index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Languages.youtubevideo,
            style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                  future: Future.value(seleted),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        spacing: 10,
                        children: [
                          MediaQuery.removePadding(
                            context: context,
                            removeBottom: true,
                            child: CuPlayerScreen(
                              url: snapshot.data?.videoUrl ?? "",
                              isLive: false,
                              playerType: PlayerType.youtube,
                              canpop: false,
                              autoPLay: true,
                              children: const [],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              snapshot.data?.title ?? "",
                              style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
                            ),
                          )
                        ],
                      );
                    }
                  }),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Related Videos",
                      style: GoogleFonts.notoSansDevanagari(
                        color: ColorResources.textblack,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AlignedGridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.videData.length,
                        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                seleted = widget.videData[index];
                              });
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
                                    videoUrl: widget.videData[index].videoUrl,
                                    height: 125,
                                    istapable: () {},
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    widget.videData[index].title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
