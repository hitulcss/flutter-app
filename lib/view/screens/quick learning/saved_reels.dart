import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/shorts/get_short_video.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/short_type.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/short_learning.dart';

class SavedReelsScreen extends StatefulWidget {
  const SavedReelsScreen({super.key});

  @override
  State<SavedReelsScreen> createState() => _SavedReelsScreenState();
}

class _SavedReelsScreenState extends State<SavedReelsScreen> {
  int page = 1;
  bool isReachedMax = false;
  final ScrollController _scrollController = ScrollController();
  List<Short> savedData = [];
  @override
  void initState() {
    super.initState();
    analytics.logScreenView(screenName: "saved_reels_screen", screenClass: "SavedReelsScreen");
    fetchdata();
  }

  Future<void> fetchdata() async {
    RemoteDataSourceImpl().getMySavedShort(page: page).then((snapshot) {
      if (snapshot.status ?? false) {
        if (mounted) {
          safeSetState(() {
            savedData.addAll(snapshot.data?.shorts ?? []);
            page++;
            isReachedMax = (snapshot.data?.shorts?.length ?? 0) == (snapshot.data?.totalCounts ?? 0);
          });
        }
      }
    }).onError(
      (error, stackTrace) {
        analytics.logEvent(
          name: "error",
          parameters: {
            "error": error.toString(),
            "stackTrace": stackTrace.toString(),
            "page": page,
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Shorts'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return fetchdata();
        },
        child: savedData.isEmpty
            ? Center(
                child: Container(
                  constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.3, maxWidth: MediaQuery.sizeOf(context).width * 0.7),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Spacer(),
                        CircleAvatar(
                          radius: 40,
                          child: Icon(
                            Icons.bookmark_border,
                            size: 60,
                            color: ColorResources.buttoncolor,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'No saved shorts found.',
                          style: GoogleFonts.notoSansDevanagari(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: ColorResources.textblack,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              )
            : GridView.builder(
                padding: EdgeInsets.all(10),
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6,
                ),
                itemCount: savedData.length,
                itemBuilder: (context, index) {
                  Short data = savedData[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ShortLearningScreen(
                          shortType: ShortType.saved,
                          shorts: savedData,
                          page: page,
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
                                maxHeight: 400,
                                maxWidth: 900,
                                quality: 90,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.fitWidth,
                                  );
                                } else if (snapshot.hasError) {
                                  // log(snapshot.error.toString());
                                  return Center(
                                    child: Text("error"),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  stops: [
                                    0.05,
                                    1
                                  ],
                                  colors: [
                                    Colors.black,
                                    Colors.transparent
                                  ],
                                ),
                              ),
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
    );
  }
}
