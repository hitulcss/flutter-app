import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  String? _profileimage;

  @override
  void initState() {
    super.initState();
    analytics.logScreenView(screenName: "app_profile");
    _profileimage = SharedPreferenceHelper.getString(Preferences.profileImage) != "N/A" ? SharedPreferenceHelper.getString(Preferences.profileImage)! : SvgImages.avatar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          'Profile',
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: CachedNetworkImageProvider(SvgImages.backgroung),
            //   fit: BoxFit.fill,
            //   repeat: ImageRepeat.noRepeat,
            // ),
            gradient: LinearGradient(
          colors: [
            ColorResources.buttoncolor.withValues(alpha: 0.5),
            Colors.white
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 20,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundImage: CachedNetworkImageProvider(_profileimage!),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    Text(
                      SharedPreferenceHelper.getString(Preferences.name).toString(),
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: ColorResources.textWhite,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SelectableText(
                      SharedPreferenceHelper.getString(Preferences.enrollId) ?? '',
                      style: TextStyle(
                        color: ColorResources.textWhite,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('editprofilescreen').then((value) {
                  safeSetState(() {
                    _profileimage = SharedPreferenceHelper.getString(Preferences.profileImage)!;
                  });
                }),
                child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width * 0.90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorResources.textWhite,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_circle_outlined, size: 35),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Languages.personalInformation,
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                Languages.editProfile,
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack.withValues(alpha: 0.5),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.of(context).pushReplacement(MaterialPageRoute(
              //       builder: (context) => const HomeScreen(
              //         index: 2,
              //       ),
              //     ));
              //   },
              //   child: Container(
              //     height: 80,
              //     width: MediaQuery.of(context).size.width * 0.90,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20),
              //       color: ColorResources.textWhite,
              //       boxShadow: const [
              //         BoxShadow(
              //           color: Colors.grey,
              //           blurRadius: 5.0,
              //         ),
              //       ],
              //     ),
              //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.max,
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: [
              //         Row(
              //           mainAxisSize: MainAxisSize.max,
              //           children: [
              //             const Icon(Icons.bookmark, size: 35),
              //             const SizedBox(
              //               width: 20,
              //             ),
              //             Column(
              //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text(
              //                   Languages.yourTestSeries,
              //                   style: GoogleFonts.notoSansDevanagari(
              //                     color: ColorResources.textblack,
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 Text(
              //                   Languages.seeYourEnrollTest,
              //                   style: GoogleFonts.notoSansDevanagari(
              //                     color: ColorResources.textblack.withValues(alpha:0.5),
              //                     fontSize: 10,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 )
              //               ],
              //             ),
              //           ],
              //         ),
              //         const Expanded(child: SizedBox()),
              //         const Icon(Icons.arrow_forward_ios)
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('mycoursesscreen');
                },
                child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width * 0.90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorResources.textWhite,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_stories, size: 35),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Languages.courses,
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                Languages.seeYourEnrollCourses,
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack.withValues(alpha: 0.5),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => callApilogout(),
                child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width * 0.90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorResources.textWhite,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.logout,
                            size: 35,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Logout',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  callApilogout() async {
    analytics.logEvent(name: "app_logout");
    //Logout response;
    safeSetState(() {
      Preferences.onLoading(context);
    });
    try {
      //var token = SharedPreferenceHelper.getString(Preferences.access_token);
      //response = await RestClient(RetroApi().dioData(token!)).logoutRequest();
      //if (response.status!) {
      safeSetState(() {
        Preferences.hideDialog(context);
      });
      // Fluttertoast.showToast(
      //   msg: '${response.msg}',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: ColorResources.gray,
      //   textColor: ColorResources.textWhite,
      // );
      SharedPreferenceHelper.clearPref();
      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      // } else {
      //   Fluttertoast.showToast(
      //     msg: '${response.msg}',
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     backgroundColor: ColorResources.gray,
      //     textColor: ColorResources.textWhite,
      //   );
      // }
    } catch (error) {
      safeSetState(() {
        Preferences.hideDialog(context);
      });
      // print("Exception occur: $error stackTrace: $stacktrace");
      // return BaseModel()..setException(ServerError.withError(error: error));
    }
    //return BaseModel()..data = response;
  }
}
