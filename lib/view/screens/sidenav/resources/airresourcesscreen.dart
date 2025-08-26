import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/resources/resources_data_sources_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/air_resource_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';

class AirResourcesScreen extends StatefulWidget {
  const AirResourcesScreen({super.key});
  @override
  State<AirResourcesScreen> createState() => _AirResourcesScreenState();
}

class _AirResourcesScreenState extends State<AirResourcesScreen> {
  // final TextEditingController _searchtest = TextEditingController();
  final player = AudioPlayer();

  final ResourceDataSourceImpl resourceDataSourceImpl = ResourceDataSourceImpl();
  Duration? duration;

  String? audioname;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          'AIR',
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<AirResourcesModel>(
          future: resourceDataSourceImpl.getAir(),
          builder: (context, snapshots) {
            if (ConnectionState.done == snapshots.connectionState) {
              if (snapshots.hasData) {
                AirResourcesModel? response = snapshots.data;
                if (response!.status) {
                  return _bodyWidget(response.data, context);
                } else {
                  return Text(response.msg);
                }
              } else {
                return Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.6, width: MediaQuery.of(context).size.width * 0.8, child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"))
                    //Text('Pls Refresh (or) Reopen App'),
                    );
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget _bodyWidget(List<AirResourcesDataModel> resources, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SearchBarWidget(
              //   searchText: 'Search Air',
              //   onChanged: (String value) {
              //     print(value);
              //   },
              // ),
              FractionallySizedBox(
                widthFactor: 0.95,
                child: resources.isNotEmpty
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: resources.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return aircard(resources[index]);
                        },
                      )
                    : EmptyWidget(image: SvgImages.emptyresource, text: Preferences.appString.noResources?? Languages.noresources),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget aircard(AirResourcesDataModel resources) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: ColorResources.borderColor),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.radio_outlined,
                size: 30,
                weight: 100,
                grade: 10,
                opticalSize: 24,
                color: ColorResources.buttoncolor,
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Text(
                      resources.data,
                      overflow: TextOverflow.clip,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: ColorResources.gray,
                      ),
                    ),
                  ),
                  Text(
                    resources.audioFile.fileSize,
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 10,
                      color: ColorResources.gray,
                    ),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () async {
              duration = await player.setUrl(resources.audioFile.fileLoc);
              if (player.playing) {
                player.stop();
                audioname = "";
              } else {
                player.play();
                audioname = resources.data;
              }
            },
            child: StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              //initialData: initialData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // final playerstate = snapshot.data;
                final proccesingstsate = PlayerState(
                  player.playing,
                  player.processingState,
                );
                // final bool isplaying = player.playing;
                return audioname == resources.data
                    ? proccesingstsate.processingState.index == 1 || proccesingstsate.processingState.index == 2
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            children: [
                              Icon(
                                Icons.pause,
                                size: 25,
                                color: ColorResources.buttoncolor,
                              ),
                              Text(Languages.pause,
                                  style: GoogleFonts.notoSansDevanagari(
                                    fontSize: 8,
                                    color: ColorResources.buttoncolor,
                                    fontWeight: FontWeight.w700,
                                  ))
                            ],
                          )
                    : Column(
                        children: [
                          Icon(
                            Icons.play_arrow,
                            size: 25,
                            color: ColorResources.buttoncolor,
                          ),
                          Text(
                            Languages.audioplay,
                            style: GoogleFonts.notoSansDevanagari(
                              fontSize: 8,
                              color: ColorResources.buttoncolor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      );
              },
            ),
            //
          )
        ],
      ),
    );
  }
}
