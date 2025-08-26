import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/stream_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/cus_player.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/library/youtube/see_more_yt.dart';
import 'package:sd_campus_app/view/screens/library/youtube/youtube_video_detail.dart';
import 'package:skeletonizer/skeletonizer.dart';

class YoutubeLearningScreen extends StatefulWidget {
  final String title;
  final StreamDataModel streamDataModel;
  const YoutubeLearningScreen({super.key, required this.title, required this.streamDataModel});

  @override
  State<YoutubeLearningScreen> createState() => _YoutubeLearningScreenState();
}

class _YoutubeLearningScreenState extends State<YoutubeLearningScreen> {
  SubCategories selected = SubCategories();
  @override
  void initState() {
    super.initState();
    if (widget.streamDataModel.subCategories?.isNotEmpty ?? false) {
      selected = widget.streamDataModel.subCategories?.first ?? SubCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 5,
                  children: List.generate(
                    widget.streamDataModel.subCategories?.length ?? 0,
                    (index) => ChoiceChip(
                      selected: selected == widget.streamDataModel.subCategories?[index],
                      selectedColor: ColorResources.buttoncolor,
                      showCheckmark: false,
                      labelStyle: TextStyle(color: selected == widget.streamDataModel.subCategories?[index] ? ColorResources.textWhite : ColorResources.textblack),
                      onSelected: (value) {
                        selected = widget.streamDataModel.subCategories?[index] ?? SubCategories();
                        safeSetState(() {});
                      },
                      label: Text(widget.streamDataModel.subCategories?[index].title ?? ""),
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                  future: RemoteDataSourceImpl().getVideoLeariningLibraryRequest(subCategory: selected.id ?? "", catagory: widget.streamDataModel.sId ?? ""),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      // print(snapshot.error);
                      return ErrorWidgetapp(image: SvgImages.error404, text: snapshot.error.toString());
                    }
                    return snapshot.data?.data?.isEmpty ?? true
                        ? EmptyWidget(image: SvgImages.dppNoteslive, text: "No Videos Found")
                        : Column(
                            spacing: 10,
                            children: snapshot.data?.data
                                    ?.map((e) => Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: ColorResources.borderColor),
                                          ),
                                          child: Column(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    e.subject ?? "",
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  if ((e.videos?.length ?? 0) > 3)
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => SeeMoreYtScreen(
                                                                  title: e.subject ?? "",
                                                                  videos: e.videos ?? [],
                                                                )));
                                                      },
                                                      child: Text(
                                                        Preferences.appString.libViewAll ?? "See All",
                                                        style: TextStyle(color: ColorResources.buttoncolor),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Divider(),
                                            SizedBox(
                                              height: 180,
                                              child: ListView.builder(
                                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                                  itemCount: e.videos?.length ?? 0,
                                                  scrollDirection: Axis.horizontal,
                                                  itemBuilder: (context, index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => YoutubeVideoDetailScreen(
                                                                  selectedVideo: e.videos![index],
                                                                  videos: e.videos ?? [],
                                                                )));
                                                      },
                                                      child: Container(
                                                        constraints: BoxConstraints(maxWidth: 200),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(color: ColorResources.borderColor),
                                                          color: Colors.white,
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius: BorderRadius.circular(10),
                                                                child: FutureBuilder<String>(
                                                                    future: youtubeThumblineurl(videoId: e.videos?[index].url ?? ""),
                                                                    builder: (context, snapshot) {
                                                                      return Skeletonizer(
                                                                        enabled: snapshot.connectionState == ConnectionState.waiting,
                                                                        child: CachedNetworkImage(
                                                                          imageUrl: snapshot.data ?? SvgImages.noImageVideo,
                                                                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                                          errorWidget: (context, url, error) => Center(
                                                                              child: CachedNetworkImage(
                                                                            imageUrl: SvgImages.noImageVideo,
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
                                                              Expanded(
                                                                child: Center(
                                                                    child: Text(
                                                                  e.videos?[index].title ?? "",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  // textAlign: TextAlign.center,
                                                                  style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack, fontWeight: FontWeight.w600),
                                                                )),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ]),
                                        ))
                                    .toList() ??
                                []);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
