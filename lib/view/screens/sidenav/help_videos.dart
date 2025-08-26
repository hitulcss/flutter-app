import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/presentation/widgets/cus_player.dart';
import 'package:sd_campus_app/models/gethelp_and_support.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/enum/playertype.dart';
import 'package:sd_campus_app/util/images_file.dart';

class HelpVideosList extends StatelessWidget {
  final List<Video> videos;
  const HelpVideosList({super.key, required this.videos});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Videos'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: videos.length,
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.all(5),
          constraints: BoxConstraints(
            maxWidth: 200,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: CuPlayerScreen(
                        canpop: true,
                        playerType: (videos[index].type ?? "yt") == "yt" ? PlayerType.youtube : PlayerType.network,
                        url: videos[index].url ?? "",
                        wallpaper: videos[index].banner ?? SvgImages.aboutLogo,
                        isLive: false,
                        autoPLay: true,
                        children: [],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  constraints: BoxConstraints(
                    minHeight: 100,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorResources.gray,
                      image: DecorationImage(
                        image: NetworkImage(
                          videos[index].banner ?? SvgImages.aboutLogo,
                        ),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorResources.borderColor,
                          blurRadius: 55,
                          spreadRadius: 0,
                          offset: Offset(0, 4),
                        )
                      ]),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    videos[index].title ?? "Context",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ColorResources.textblack,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
