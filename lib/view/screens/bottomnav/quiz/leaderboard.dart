import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/data/remote/models/leaderboard.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';

class LeaderboardScreen extends StatelessWidget {
  final String title;
  final LeaderboardsModel data;
  const LeaderboardScreen({super.key, required this.title, required this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: ColorResources.textWhite,
      //   iconTheme: IconThemeData(color: ColorResources.textblack),
      //   title: Text(
      //     'Leaderboard',
      //     style: GoogleFonts.notoSansDevanagari(
      //       color: ColorResources.textblack,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0x3F000000).withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorResources.buttoncolor.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CachedNetworkImage(
                        placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        imageUrl: SvgImages.leaderbord_star),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: ColorResources.buttoncolor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              // Container(
              //   padding: EdgeInsets.all(8),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         "Today",
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           color: ColorResources.buttoncolor,
              //         ),
              //       ),
              //       Text(
              //         "This Week",
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           color: ColorResources.textblack,
              //         ),
              //       ),
              //       Text(
              //         "Month",
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           color: ColorResources.textblack,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(10),
                  color: ColorResources.buttoncolor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rank",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: ColorResources.textWhite,
                      ),
                    ),
                    Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ColorResources.textWhite,
                      ),
                    ),
                    Text(
                      "Score",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ColorResources.textWhite,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                // height: MediaQuery.of(context).size.height * 0.55,
                child: ListView.separated(
                  //physics: NeverScrollableScrollPhysics(),
                  itemCount: data.data!.leaderBoard!.length,
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: ColorResources.textblack,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                              child: Text(
                                data.data!.leaderBoard![index].studentName!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: ColorResources.textblack,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          Text(
                            data.data!.leaderBoard![index].myScore.toString(),
                            style: TextStyle(
                              color: ColorResources.textblack,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
