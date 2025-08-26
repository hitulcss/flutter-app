import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/stream_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/carousel_slider_app.dart';
import 'package:sd_campus_app/features/presentation/widgets/cus_player.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/playertype.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/extenstions/string_extenstions.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/home.dart';

class OurResultScreen extends StatefulWidget {
  const OurResultScreen({super.key});

  @override
  State<OurResultScreen> createState() => _OurResultScreenState();
}

class _OurResultScreenState extends State<OurResultScreen>
    with SingleTickerProviderStateMixin {
  StreamModel getStreamsApi = StreamModel.fromJson(json
      .decode(SharedPreferenceHelper.getString(Preferences.getStreamsApi)!));
  TabController? _tabController;
  int? selectedYear = 2025;
  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: getStreamsApi.data?.length ?? 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Result'),
        actions: [
          PopupMenuButton(
              icon: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: ColorResources.borderColor,
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      Text(selectedYear.toString()),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              onSelected: (value) => safeSetState(() => selectedYear = value),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 2025,
                      child: Text('2025'),
                    ),
                    PopupMenuItem(
                      value: 2024,
                      child: Text('2024'),
                    ),
                  ]),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: getStreamsApi.data
                  ?.map((e) => Tab(text: e.title ?? "catagory"))
                  .toList() ??
              [],
        ),
      ),
      body: (getStreamsApi.data != null && getStreamsApi.data!.isNotEmpty)
          ? TabBarView(
              controller: _tabController,
              children: List.generate(getStreamsApi.data?.length ?? 0, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        FutureBuilder(
                            future: RemoteDataSourceImpl().getResultBannerRequest(year: selectedYear.toString(), streamid: getStreamsApi.data?[index].sId.toString()),
                            builder: (context, snapshot) {
                              return snapshot.data?.data?.isEmpty ?? true
                                  ? SizedBox()
                                  : CarouselSliderApp(
                                      images: snapshot.data?.data
                                              ?.map((e) => e.banner ?? "")
                                              .toList() ??
                                          [],
                                    );
                            }),
                        FutureBuilder(
                            future: RemoteDataSourceImpl()
                                .getResultStoreRequest(
                                    year: selectedYear.toString(),
                                    streamid: getStreamsApi.data?[index].sId
                                        .toString()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData &&
                                  snapshot.data?.data != null &&
                                  snapshot.data!.data!.isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 10,
                                  children: [
                                    Wrap(
                                      children: [
                                        Text('Student Success '),
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 15,
                                        ),
                                        Text(
                                          ' Stories',
                                          style: TextStyle(
                                            color: ColorResources.buttoncolor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: ColorResources.borderColor,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 10,
                                        children: [
                                          if (snapshot.data?.data?.first.url
                                                  ?.isNotEmpty ??
                                              false)
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => Dialog(
                                                    child: CuPlayerScreen(
                                                      url: snapshot.data?.data
                                                              ?.first.url ??
                                                          "",
                                                      isLive: false,
                                                      playerType:
                                                          PlayerType.youtube,
                                                      canpop: true,
                                                      autoPLay: true,
                                                      children: [],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: AspectRatio(
                                                      aspectRatio: 16 / 9,
                                                      child: FutureBuilder(
                                                        future:
                                                            youtubeThumblineurl(
                                                                videoId: snapshot
                                                                        .data
                                                                        ?.data
                                                                        ?.first
                                                                        .url ??
                                                                    ""),
                                                        builder: (context,
                                                                psnapshot) =>
                                                            psnapshot.data
                                                                        ?.isNotEmpty ??
                                                                    false
                                                                ? CachedNetworkImage(
                                                                    imageUrl:
                                                                        psnapshot.data ??
                                                                            "",
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        const Center(
                                                                            child:
                                                                                CircularProgressIndicator()),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons.error),
                                                                  )
                                                                : const Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 10,
                                                    left: 10,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Icon(
                                                        Icons
                                                            .play_circle_fill_outlined,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          Text(
                                            snapshot.data?.data?.first.desc ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Row(
                                            spacing: 10,
                                            children: [
                                              CircleAvatar(
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        snapshot
                                                                .data
                                                                ?.data
                                                                ?.first
                                                                .user
                                                                ?.profile ??
                                                            SvgImages.avatar),
                                                radius: 17,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    (snapshot.data?.data?.first
                                                                .user?.name ??
                                                            '')
                                                        .toCapitalize(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${snapshot.data?.data?.first.category ?? ''} | ${snapshot.data?.data?.first.resultInfo ?? ''}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    if ((snapshot.data?.data?.length ?? 0) >= 2)
                                      SizedBox(
                                        height: 350,
                                        child: ListView.separated(
                                          itemCount:
                                              (snapshot.data?.data?.length ??
                                                      0) -
                                                  1,
                                          scrollDirection: Axis.horizontal,
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                            width: 10,
                                          ),
                                          itemBuilder: (context, index) =>
                                              Container(
                                            padding: EdgeInsets.all(8),
                                            constraints:
                                                BoxConstraints(maxWidth: 300),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color:
                                                    ColorResources.borderColor,
                                              ),
                                            ),
                                            child: Column(
                                              spacing: 10,
                                              children: [
                                                if (snapshot.data?.data?[index + 1].url?.trim().isNotEmpty ?? false)
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            Dialog(
                                                          child: CuPlayerScreen(
                                                            url: snapshot.data?.data?[index + 1].url ?? "",
                                                            isLive: false,
                                                            playerType:
                                                                PlayerType
                                                                    .youtube,
                                                            canpop: true,
                                                            autoPLay: true,
                                                            children: [],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: AspectRatio(
                                                            aspectRatio: 16 / 9,
                                                            child: FutureBuilder(
                                                              future: youtubeThumblineurl(videoId: snapshot.data?.data?[index + 1].url ?? ""),
                                                              builder: (context, psnapshot) => psnapshot.data?.isNotEmpty ?? false
                                                                  ? CachedNetworkImage(
                                                                      imageUrl: psnapshot.data ?? "",
                                                                      fit: BoxFit.fill,
                                                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                    )
                                                                  : const Center(
                                                                      child: CircularProgressIndicator(),
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: 10,
                                                          left: 10,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Icon(
                                                              Icons
                                                                  .play_circle_fill_outlined,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                Expanded(
                                                  child: Scrollbar(
                                                    // thumbVisibility: true,
                                                    trackVisibility: true,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Text(
                                                        snapshot
                                                                .data
                                                                ?.data?[
                                                                    index + 1]
                                                                .desc ??
                                                            "",
                                                        // The personalized study plan kept me motivated and focused throughout my preparation. I couldnt have asked for a better learning experience!' ,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          // fontWeight: FontWeight.bold,
                                                          // fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  spacing: 10,
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage:
                                                          CachedNetworkImageProvider(
                                                              snapshot
                                                                      .data
                                                                      ?.data?[
                                                                          index +
                                                                              1]
                                                                      .user
                                                                      ?.profile ??
                                                                  SvgImages
                                                                      .avatar),
                                                      radius: 17,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          snapshot
                                                                  .data
                                                                  ?.data?[
                                                                      index + 1]
                                                                  .user
                                                                  ?.name ??
                                                              '',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          snapshot
                                                                  .data
                                                                  ?.data?[index]
                                                                  .category ??
                                                              '',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 10,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                );
                              } else {
                                return SizedBox();
                              }
                            }),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: ColorResources.borderColor,
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Image.network(
                                SvgImages.thankyou,
                                height: 200,
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'We thanks ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'our Students ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorResources.buttoncolor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' &',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Their Parents ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorResources.buttoncolor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'for their trust in us!',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.popUntil(
                                        context, (route) => false);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeScreen(
                                            index: 1,
                                          ),
                                        ));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'BE A PART OF SD CAMPUS NOW',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }))
          : SizedBox(),
    );
  }
}
