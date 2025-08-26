// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/line_md.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sd_campus_app/features/controller/auth_controller.dart';
import 'package:sd_campus_app/features/cubit/streamselect/streamsetect_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/auth/auth_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/pincode_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/app%20tour/tour_next_back_button.dart';
import 'package:sd_campus_app/features/presentation/widgets/search_course.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/enum/feature_enum.dart';
import 'package:sd_campus_app/util/enum/short_type.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/fcm_routing.dart';
import 'package:sd_campus_app/util/extenstions/string_extenstions.dart';
import 'package:sd_campus_app/util/showcase_tour.dart';
import 'package:sd_campus_app/view/screens/Community/Community_home.dart';
import 'package:sd_campus_app/view/screens/e_book/ebooks.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/short_learning.dart';
import 'package:sd_campus_app/view/screens/sidenav/our_result.dart';
import 'package:sd_campus_app/view/screens/sidenav/privacyPolicy.dart';
import 'package:sd_campus_app/view/screens/sidenav/refer/refer_and_earn.dart';
import 'package:sd_campus_app/view/screens/sidenav/refer/wallet.dart';
import 'package:sd_campus_app/api/base_model.dart';
import 'package:sd_campus_app/api/server_error.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/bottomnav/coursescreen.dart';
import 'package:sd_campus_app/view/screens/bottomnav/homescreen.dart';
import 'package:sd_campus_app/view/screens/bottomnav/profile.dart';
import 'package:sd_campus_app/view/screens/sidenav/termsConditions.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  final int? index;
  const HomeScreen({super.key, this.index});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool notificationrec = false;
  PackageInfo? packageInfo;

  String? selectedStream = "";

  TextEditingController nameController = TextEditingController();
  String address = SharedPreferenceHelper.getString(Preferences.address) ?? "";
  void _onItemTapped(int index) {
    if (index <= 3) {
      safeSetState(() {
        _selectedIndex = index;
      });
    }
    // else if (index == 2) {
    //   implementSsoSdk();
    // }
    else {
      Preferences.remoteStore["islink"] ? launchUrl(Uri.parse(Preferences.remoteStore["link"]), mode: LaunchMode.externalApplication) : Navigator.of(context).pushNamed("store");
    }
  }

  final List _widgetOptions = [
    const HomeScreens(),
    const CourseScreen(),
    const CommunityFeedsScreen(),
    const EBookScreen(),
    // const QuizListScreen(),
    // Mocktestscreen(remoteDataSourceImpl: RemoteDataSourceImpl()),
    // const MySchedule()
    // const ProfilScreen(),
  ];

  String name = "temp";
  Future<void> initDynamicLinks() async {
    // print("Deeplink");
    final PendingDynamicLinkData? initialLink = await Preferences.dynamicLinks.getInitialLink();
    if (initialLink != null) {
      // print("link");
      // print(initialLink.asMap());
      final Uri deepLink = initialLink.link;
      RemoteMessage remot = RemoteMessage.fromMap({
        "data": {
          "route": deepLink.queryParameters["route"],
          "rootId": deepLink.queryParameters["rootId"],
          "childId": deepLink.queryParameters["childId"]
        }
      });
      // print("*" * 100);
      // print(remot.data);
      // print("*" * 100);
      // print(deepLink.data);
      fcmRouting(context: context, message: remot);
      // Example of using the dynamic link to push the user to a different screen
      // Navigator.pushNamed(context, deepLink.path);
    }
    Preferences.dynamicLinks.onLink.listen((dynamicLinkData) {
      // print("test");
      // print("*" * 100);
      // print('${dynamicLinkData.link.path}');
      // print("*" * 100);
      // Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      // print('onLink error');
      // print(error.message);
    });
  }

  @override
  void initState() {
    WakelockPlus.enable();
    PackageInfo.fromPlatform().then((package) {
      safeSetState(() {
        packageInfo = package;
      });
    });
    initDynamicLinks();
    //print(ColorResources.buttoncolor);
    // Preferences.checkLocationPermission(context);
    analytics.setUserProperty(
      name: SharedPreferenceHelper.getString(Preferences.name)?.toLowerCase().trim().replaceAll(RegExp(r'[^a-zA-Z0-9]'), "_") ?? "Unknown",
      value: SharedPreferenceHelper.getString(Preferences.enrollId) ?? analytics.getSessionId().toString(),
    );
    analytics.setDefaultEventParameters({
      "name": (SharedPreferenceHelper.getString(Preferences.name) ?? "Unknown").toLowerCase().trim().replaceAll(RegExp(r'[^a-zA-Z0-9]'), "_"),
      "phoneNumber": SharedPreferenceHelper.getString(Preferences.phoneNUmber) ?? "Unknown",
      "email": SharedPreferenceHelper.getString(Preferences.email) ?? "Unknown",
      "id": SharedPreferenceHelper.getString(Preferences.enrollId) ?? analytics.getSessionId().toString(),
    });
    analytics.logEvent(name: "app_loggedin_Home", parameters: {
      "name": (SharedPreferenceHelper.getString(Preferences.name) ?? "Unknown").toLowerCase().trim().replaceAll(RegExp(r'[^a-zA-Z0-9]'), "_"),
      "phoneNumber": SharedPreferenceHelper.getString(Preferences.phoneNUmber) ?? "Unknown",
      "email": SharedPreferenceHelper.getString(Preferences.email) ?? "Unknown",
      "id": SharedPreferenceHelper.getString(Preferences.enrollId) ?? analytics.getSessionId().toString(),
    });
    selectedStream = SharedPreferenceHelper.getStringList(Preferences.getStreams).isEmpty ? "Select Stream" : SharedPreferenceHelper.getStringList(Preferences.getStreams).first;
    AuthController().getStream();
    widget.index != null ? _onItemTapped(widget.index!) : print("back");

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      // print("message on getInitialMessage");
      RemoteNotification? notification;
      if (message != null) {
        notification = message.notification;
        // AndroidNotification? android = message.notification?.android;
        if (mounted) {
          safeSetState(() {
            notificationrec = true;
          });
        }
        if (message.data.containsKey('route')) {
          fcmRouting(context: context, message: message);
        } else {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification!.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.body!),
                      notification.android!.imageUrl != null
                          ? CachedNetworkImage(
                              placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              imageUrl: notification.android!.imageUrl!)
                          : Container(),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }
    });

    FirebaseMessaging.onBackgroundMessage((message) async {
      await Firebase.initializeApp();
      // print("message on background");
      if (mounted) {
        safeSetState(() {
          notificationrec = true;
        });
      }
      RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;
      if (message.data.containsKey('route') && mounted) {
        fcmRouting(context: context, message: message);
      } else {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification!.title!),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.body!),
                    notification.android!.imageUrl != null
                        ? CachedNetworkImage(
                            placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            imageUrl: notification.android!.imageUrl!)
                        : Container(),
                  ],
                ),
              ),
            );
          },
        );
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      if (mounted) {
        safeSetState(() {
          notificationrec = true;
        });
      }

      RemoteNotification? notification = message?.notification;
      // AndroidNotification? android = message.notification?.android;
      if (message?.data.isNotEmpty ?? false) {
        //Handle push notification redirection here

        if (message?.data.containsKey('route') ?? true) {
          // fcmRouting(context: context, message: message);
        } else {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification!.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.body!),
                      notification.android?.imageUrl != null
                          ? CachedNetworkImage(
                              placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              imageUrl: notification.android!.imageUrl!)
                          : Container(),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        if (mounted) {
          safeSetState(() {
            notificationrec = true;
          });
        }
        // print('*' * 2000);
        // print('A new onMessageOpenedApp event was published!');
        // RemoteNotification? notification = message.notification;
        // AndroidNotification? android = message.notification?.android;
        // if (notification != null && android != null) {
        //   if (message.data.containsKey('route')) {
        //     fcmRouting(context: context, message: message);
        //   } else {
        //     showDialog(
        //       context: context,
        //       builder: (_) {
        //         return AlertDialog(
        //           title: Text(notification.title!),
        //           content: SingleChildScrollView(
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(notification.body!),
        //                 notification.android!.imageUrl != null ? Image.network(notification.android!.imageUrl!) : Container(),
        //               ],
        //             ),
        //           ),
        //         );
        //       },
        //     );
        //   }
        // }
      },
    );
    // print('Is english');
    // print(Languages.isEnglish);
    name = SharedPreferenceHelper.getString(Preferences.name)!;
    // Languages.isEnglish = SharedPreferenceHelper.getBoolean(Preferences.language)
    Languages.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!SharedPreferenceHelper.getStringList(Preferences.showTour).contains(Preferences.homeTour)) {
        ShowCaseWidget.of(context).startShowCase(
          [
            sideMenu,
            topcatagory,
            courseSearchbar,
            notification,
            learning,
            coursebottom,
            feed,
            ebookbottom,
            storebottom,
          ],
        );
        SharedPreferenceHelper.setStringList(Preferences.showTour, SharedPreferenceHelper.getStringList(Preferences.showTour)..add(Preferences.homeTour));
      }
      // print(SharedPreferenceHelper.getBoolean(Preferences.awareness));
      if (Preferences.remoteAppInfo["forceupdate"]) {
        InAppUpdate.checkForUpdate().then((value) {
          if (Preferences.remoteAppInfo["versioncode"] == "ALL") {
            updatecheck();
          } else if (value.availableVersionCode != null && value.availableVersionCode! <= int.parse(Preferences.remoteAppInfo["versioncode"])) {
            updatecheck();
          }
        }).catchError((e) {});
      }

      if (Preferences.awareApp["isActive"]) {
        Preferences.awarenessPopup(context).then((value) {
          if (address.isEmpty || address == "N/A") {
            addresscheck(context).then((_) {
              if (SharedPreferenceHelper.getString(Preferences.name)!.isEmpty || SharedPreferenceHelper.getString(Preferences.name) == "N/A" || SharedPreferenceHelper.getString(Preferences.name) == "Name") {
                namecheck();
              }
            });
          }
        });
      } else if (address.isEmpty || address == "N/A") {
        addresscheck(context).then((_) {
          if (SharedPreferenceHelper.getString(Preferences.name)!.isEmpty || SharedPreferenceHelper.getString(Preferences.name) == "N/A" || SharedPreferenceHelper.getString(Preferences.name) == "Name") {
            namecheck();
          }
        });
      } else if (SharedPreferenceHelper.getString(Preferences.name)!.isEmpty || SharedPreferenceHelper.getString(Preferences.name) == "N/A" || SharedPreferenceHelper.getString(Preferences.name) == "Name") {
        namecheck();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    nameController.dispose();
    super.dispose();
  }

  void namecheck() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Enter Your Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorResources.textblack,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: nameController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ?!@#\$%^&*/\n]"))
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Enter name"),
                  hintText: "ex:sai ram",
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: ColorResources.buttoncolor),
                      onPressed: () {
                        if (nameController.text == "" || nameController.text == "N/A" || nameController.text.trim().isEmpty) {
                          flutterToast("Please Enter Name");
                        } else {
                          AuthDataSourceImpl().updateUserDetails(nameController.text, SharedPreferenceHelper.getString(Preferences.email)!, SharedPreferenceHelper.getString(Preferences.address)!).then((value) {
                            SharedPreferenceHelper.setString(Preferences.name, nameController.text);
                            Navigator.of(context).pop();
                          });
                        }
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  // Future<void> implementSsoSdk() async {
  //   try {
  //     print("object" * 10);
  //     final String result = await platform.invokeMethod("implementSsoSdk");
  //     response = result;
  //   } on PlatformException catch (e) {
  //     response = "Failed to Invoke: '${e.message}'.";
  //   }
  //   safeSetState(() {
  //     _implementSsoSdk = response;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onbackpress(context),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Showcase(
            titleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            titleAlignment: Alignment.centerLeft,
            key: topcatagory,
            title: Preferences.apptutor.topcatagory?.title,
            description: Preferences.apptutor.topcatagory?.des ?? 'Click to select Category or Change Stream',
            tooltipActionConfig: const TooltipActionConfig(
              alignment: MainAxisAlignment.spaceBetween,
              actionGap: 16,
              position: TooltipActionPosition.outside,
              gapBetweenContentAndAction: 16,
            ),
            tooltipActions: [
              tourPrevious(
                context: context,
              ),
              tourNext(
                context: context,
              ),
            ],
            child: PopupMenuButton(
              padding: EdgeInsets.zero,
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: BlocBuilder<StreamsetectCubit, StreamsetectState>(
                      builder: (context, state) {
                        return Text(
                          context.read<StreamsetectCubit>().getSlectedStream() ?? "Select Stream",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(height: 0.9),
                        );
                      },
                    ),
                  ),
                  const Icon(
                    Icons.arrow_right,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  // InkWell(
                  //     onTap: () {
                  //       Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => ExamCategoryScreen(),
                  //       ));
                  //     },
                  //     child: Icon(Icons.more_vert, size: 20)),
                ],
              ),
              onSelected: (value) {
                safeSetState(() {
                  selectedStream = value;
                });

                RemoteDataSourceImpl().postStreamRequest(name: value);
                context.read<StreamsetectCubit>().topCourseStreamSelected(selected: value);
              },
              itemBuilder: (context) => SharedPreferenceHelper.getStringList(Preferences.getStreams)
                  .map(
                    (e) => PopupMenuItem(
                      value: e,
                      child: Text(
                        e,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          //  Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //   decoration: BoxDecoration(
          //     border: Border.all(color: ColorResources.buttoncolor),
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   child:
          //     DropdownButtonFormField(
          //   icon: Container(),
          //   decoration: InputDecoration(
          //     contentPadding: const EdgeInsets.all(0.0),
          //     border: InputBorder.none,
          //     isDense: true,
          //   ),
          //   padding: EdgeInsets.zero,
          //   isExpanded: true,
          //   iconEnabledColor: ColorResources.buttoncolor,
          //   hint: const Text(
          //     'select Stream',
          //     overflow: TextOverflow.ellipsis,
          //   ),
          //   isDense: true,
          //   value: selectedStream,
          //   items: SharedPreferenceHelper.getStringList(Preferences.getStreams)
          //       .map(
          //         (e) => DropdownMenuItem(
          //           value: e,
          //           child: Text(
          //             e,
          //           ),
          //         ),
          //       )
          //       .toList(),
          //   onChanged: (value) async {
          //     safeSetState(() {
          //       selectedStream = value!;
          //     });
          //     RemoteDataSourceImpl().postStreamRequest(name: value!);
          //     context.read<StreamsetectCubit>().topCourseStreamSelected(selected: value);
          //   },
          //   // ),
          // ),
          // Align(
          //   alignment: Alignment.center,
          //   child: GestureDetector(
          //     onTap: () => Navigator.of(context).push(CupertinoPageRoute(
          //       builder: (context) => const QuizListScreen(),
          //     )),
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          //       decoration: BoxDecoration(
          //         color: const Color(0xFFf4b44b).withValues(alpha:0.2),
          //         borderRadius: BorderRadius.circular(20),
          //       ),
          //       child: const Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Icon(
          //             Icons.help_outline,
          //             size: 18,
          //             color: Color(0xFFf84135),
          //           ),
          //           SizedBox(
          //             width: 2,
          //           ),
          //           Text(
          //             'Daily Quiz',
          //             style: TextStyle(
          //               fontSize: 12,
          //               color: Color(0xFFf84135),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          //  SharedPreferenceHelper.getBoolean(Preferences.timerisset)
          //     ?
          //     :,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: ColorResources.textblack),
          backgroundColor: Colors.white,
          leading: Showcase(
            titleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            titleAlignment: Alignment.centerLeft,
            key: sideMenu,
            title: Preferences.apptutor.sideMenu?.title,
            description: Preferences.apptutor.sideMenu?.des ?? 'Side Menu Button',
            tooltipActionConfig: const TooltipActionConfig(
              alignment: MainAxisAlignment.spaceBetween,
              actionGap: 16,
              position: TooltipActionPosition.outside,
              gapBetweenContentAndAction: 16,
            ),
            tooltipActions: [
              tourNext(
                context: context,
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: IconButton(
                icon: const ImageIcon(
                  AssetImage('assets/images/menu_Icon.png'),
                ),
                onPressed: () {
                  analytics.logEvent(name: "app_open_drawer");
                  _scaffoldKey.currentState?.openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ),
          actions: [
            // BlocBuilder<HometimerCubit, HometimerState>(
            //   builder: (context, state) {
            //     // print(state);
            //     if (state is TimerText) {
            //       return // SharedPreferenceHelper.getBoolean(Preferences.timerisset)
            //           //?
            //           Align(
            //         alignment: Alignment.center,
            //         child: Container(
            //           margin: const EdgeInsets.symmetric(vertical: 12),
            //           child: Hometimerwidget(
            //             timeinsec: SharedPreferenceHelper.getInt(Preferences.alarmtimeinsec),
            //             style: GoogleFonts.notoSansDevanagari(
            //               color: ColorResources.buttoncolor,
            //               fontSize: 12,
            //             ),
            //           ),
            //         ),
            //       );
            //     } else {
            //       return Align(
            //         alignment: Alignment.center,
            //         child: GestureDetector(
            //           onTap: () => Navigator.of(context).push(
            //             CupertinoPageRoute(
            //               builder: (context) => const OpenTimerScreen(
            //                 time: 0,
            //               ),
            //             ),
            //           ),
            //           child: Container(
            //             margin: EdgeInsets.only(right: _selectedIndex == 1 ? 0 : 5),
            //             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            //             decoration: BoxDecoration(
            //               color: ColorResources.buttoncolor.withValues(alpha:0.1),
            //               borderRadius: BorderRadius.circular(100),
            //             ),
            //             child: Row(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 Icon(
            //                   Icons.timer_sharp,
            //                   size: 18,
            //                   color: ColorResources.buttoncolor,
            //                 ),
            //                 const SizedBox(
            //                   width: 2,
            //                 ),
            //                 Text(
            //                   Languages.timer,
            //                   style: TextStyle(
            //                     fontSize: 12,
            //                     color: ColorResources.buttoncolor,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       );
            //     }
            //   },
            // ),
            Showcase(
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              titleAlignment: Alignment.centerLeft,
              key: courseSearchbar,
              targetShapeBorder: const CircleBorder(),
              title: Preferences.apptutor.courseSearchbar?.title,
              description: Preferences.apptutor.courseSearchbar?.des ?? 'Search Course Button',
              tooltipActionConfig: const TooltipActionConfig(
                alignment: MainAxisAlignment.spaceBetween,
                actionGap: 16,
                position: TooltipActionPosition.outside,
                gapBetweenContentAndAction: 16,
              ),
              tooltipActions: [
                tourPrevious(
                  context: context,
                ),
                tourNext(
                  context: context,
                ),
              ],
              child: IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: CourseSearchWidget());
                },
                icon: Iconify(
                  MaterialSymbols.search,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () {
                  safeSetState(() {
                    notificationrec = false;
                  });
                  Navigator.of(context).pushNamed('notifications');
                },
                child: Showcase(
                  titleTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  titleAlignment: Alignment.centerLeft,
                  key: notification,
                  title: Preferences.apptutor.notification?.title,
                  description: Preferences.apptutor.notification?.des ?? 'Notification Button',
                  targetShapeBorder: const CircleBorder(),
                  tooltipActionConfig: const TooltipActionConfig(
                    alignment: MainAxisAlignment.spaceBetween,
                    actionGap: 16,
                    position: TooltipActionPosition.outside,
                    gapBetweenContentAndAction: 16,
                  ),
                  tooltipActions: [
                    tourPrevious(
                      context: context,
                    ),
                    tourNext(
                      context: context,
                    ),
                  ],
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 16,
                    child: Stack(
                      children: [
                        notificationrec
                            ? Center(
                                child: Image.asset(
                                  SvgImages.notificationRec,
                                  colorBlendMode: BlendMode.saturation,
                                  filterQuality: FilterQuality.high,
                                ),
                              )
                            : Center(
                                child: Image.asset(
                                  SvgImages.notification,
                                  colorBlendMode: BlendMode.saturation,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                        // Positioned(
                        //   top: 0,
                        //   child: Container(
                        //     margin: const EdgeInsets.only(
                        //       bottom: 11,
                        //       left: 17,
                        //       top: 9,
                        //     ),
                        //     child: const CircleAvatar(
                        //       backgroundColor: Colors.red,
                        //       radius: 3,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        drawer: Drawer(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          width: MediaQuery.of(context).size.width * 0.85,
          // shape: const RoundedRectangleBorder(
          // borderRadius: BorderRadius.only(
          //   topRight: Radius.circular(30),
          //   bottomRight: Radius.circular(30),
          // ),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => const ProfilScreen(),
                    ),
                  )
                      .then((value) {
                    safeSetState(() {
                      name = SharedPreferenceHelper.getString(Preferences.name)!;
                    });
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 60, left: 10, bottom: 20),
                  decoration: BoxDecoration(
                      // color: ColorResources.buttoncolor,
                      ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage: CachedNetworkImageProvider(SharedPreferenceHelper.getString(Preferences.profileImage) != "N/A" ? SharedPreferenceHelper.getString(Preferences.profileImage) ?? SvgImages.aboutLogo : SvgImages.aboutLogo),
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  ("Hi, ${SharedPreferenceHelper.getString(Preferences.name)!.split(" ").first.toCapitalize()}"),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  style: GoogleFonts.notoSansDevanagari(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    height: 0.9,
                                    color: ColorResources.textblack,
                                  ),
                                ),
                              ),

                              // Text(
                              //   '${Preferences.appString.userId}: ${SharedPreferenceHelper.getString(Preferences.enrollId)!}',
                              //   style: GoogleFonts.notoSansDevanagari(
                              //     fontWeight: FontWeight.w600,
                              //     fontSize: 12,
                              //     color: ColorResources.textWhite,
                              //   ),
                              // ),
                              // Text(
                              //   SharedPreferenceHelper.getString(Preferences.email) ?? '',
                              //   style: GoogleFonts.notoSansDevanagari(
                              //     fontWeight: FontWeight.w600,
                              //     fontSize: 12,
                              //     color: ColorResources.textWhite,
                              //   ),
                              // )
                              Text(
                                "View Profile",
                                style: GoogleFonts.notoSansDevanagari(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: ColorResources.textBlackSec,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(),
              // const SizedBox(
              //   height: 10,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CommunityFeedsScreen()));
              //   },
              //   child: Text("Feed", style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack, fontSize: 16, fontWeight: FontWeight.w500)),
              // ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: Preferences.remoteFutureSidebar
                        .map((element) => RowButtonWidget(
                              buttonTitle: element.title ?? "",
                              onTap: element.sidebarEnum == FeatureEnum.ourResult.name
                                  ? () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OurResultScreen()));
                                    }
                                  : element.sidebarEnum == FeatureEnum.myDownloads.name
                                      ? () {
                                          Navigator.of(context).popAndPushNamed('downloadScreen');
                                        }
                                      : element.sidebarEnum == FeatureEnum.myorders.name
                                          ? () {
                                              Navigator.of(context).popAndPushNamed('myordersscreen');
                                            }
                                          : element.sidebarEnum == FeatureEnum.shortLearning.name
                                              ? () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => ShortLearningScreen(
                                                        shortType: ShortType.feed,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              : element.sidebarEnum == FeatureEnum.mySchedule.name
                                                  ? () {
                                                      Navigator.of(context).popAndPushNamed('MySchedule');
                                                    }
                                                  : element.sidebarEnum == FeatureEnum.resource.name
                                                      ? () {
                                                          Navigator.of(context).popAndPushNamed('resourcesscreen');
                                                        }
                                                      : element.sidebarEnum == FeatureEnum.about.name
                                                          ? () {
                                                              Navigator.of(context).pop();
                                                              Navigator.of(context).pushNamed('aboutusscreen');
                                                            }
                                                          : element.sidebarEnum == FeatureEnum.referandEarn.name
                                                              ? () {
                                                                  Navigator.pop(context);
                                                                  Navigator.of(context).push(MaterialPageRoute(
                                                                    builder: (context) => const ReferEranScreen(),
                                                                  ));
                                                                }
                                                              : element.sidebarEnum == FeatureEnum.wallet.name
                                                                  ? () {
                                                                      Navigator.pop(context);
                                                                      Navigator.of(context).push(MaterialPageRoute(
                                                                        builder: (context) => const MyWalletSceen(),
                                                                      ));
                                                                    }
                                                                  : element.sidebarEnum == FeatureEnum.helpandSupport.name
                                                                      ? () {
                                                                          Navigator.of(context).popAndPushNamed('helpandsupport');
                                                                        }
                                                                      : element.sidebarEnum == FeatureEnum.dailyNews.name
                                                                          ? () {
                                                                              Navigator.of(context).popAndPushNamed('dailynews');
                                                                            }
                                                                          : element.sidebarEnum == FeatureEnum.termandSupport.name
                                                                              ? () {
                                                                                  Navigator.pop(context);
                                                                                  Navigator.of(context).push(
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) => const TermsconditionsScreen(),
                                                                                    ),
                                                                                  );
                                                                                  // launchUrl(Uri.parse("https://www.sdcampus.com/terms-and-conditions"), mode: LaunchMode.inAppWebView);
                                                                                }
                                                                              : element.sidebarEnum == FeatureEnum.privacy.name
                                                                                  ? () {
                                                                                      Navigator.pop(context);
                                                                                      Navigator.of(context).push(
                                                                                        MaterialPageRoute(
                                                                                          builder: (context) => const PrivacyPolicyScreen(),
                                                                                        ),
                                                                                      );
                                                                                      // launchUrl(Uri.parse("https://www.sdcampus.com/privacy-policy"), mode: LaunchMode.inAppWebView);
                                                                                    }
                                                                                  : () {},
                              icon: element.icon ?? LineMd.alert_circle,
                              isNew: element.isNew ?? false,
                            ))
                        .toList(),
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (Preferences.appString.slogan?.isNotEmpty ?? false)
                        Text(
                          Preferences.appString.slogan ?? '',
                          style: TextStyle(
                            color: ColorResources.textblack,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        Preferences.appString.madeby ?? '',
                        style: TextStyle(
                          color: ColorResources.textBlackSec,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'App Version : v${packageInfo?.version ?? "1.0.0"}',
                        style: TextStyle(
                          color: ColorResources.textblack,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     callApilogout();
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 16, top: 0, bottom: 10, right: 30),
              //     child: Container(
              //       padding: const EdgeInsets.all(10.0),
              //       decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(30)),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Icon(
              //             Icons.logout,
              //             color: ColorResources.buttoncolor,
              //           ),
              //           const SizedBox(
              //             width: 10,
              //           ),
              //           Text('Logout',
              //               style: GoogleFonts.notoSansDevanagari(
              //                 fontWeight: FontWeight.w500,
              //                 fontSize: 15,
              //                 color: ColorResources.buttoncolor,
              //               ))
              //         ],
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
        extendBody: false,
        // extendBodyBehindAppBar: true,
        body: _widgetOptions.elementAt(_selectedIndex),
        // if (_selectedIndex == 0)

        //       //  AspectRatio(
        //       //   aspectRatio: 16 / 9,
        //       //   child: CuPlayerScreen(
        //       //     isLive: false,
        //       //     canpop: false,
        //       //     autoPLay: true,
        //       //     children: [],
        //       //     playerType: PlayerType.youtube,
        //       //     url: "https://www.youtube.com/watch?v=-5O1vO7k3ZA&ab_channel=AVSAnand",
        //       //   ),
        //       // ),
        //       )
        //  ,
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.miniCenterDocked,
        // floatingActionButton: FloatingActionButton(
        //   shape: const CircleBorder(),
        //   onPressed: () {
        //     safeSetState(() {
        //       _selectedIndex = 2;
        //     });
        //   },
        //   elevation: 4,
        //   backgroundColor:
        //       _selectedIndex == 2 ? ColorResources.buttoncolor : Colors.white,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Icon(
        //       Icons.receipt_long,
        //       color: _selectedIndex == 2 ? Colors.white : Colors.grey,
        //     ),
        //   ),
        // ),
        bottomNavigationBar: MediaQuery.removeViewPadding(
          context: context,
          removeBottom: true,
          removeTop: true,
          child: BottomAppBar(
            padding: EdgeInsets.zero,
            color: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            elevation: 0.0,
            clipBehavior: Clip.hardEdge,
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.grey,
              elevation: 0.0,
              items: [
                BottomNavigationBarItem(
                  icon: Showcase(
                    titleTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    titleAlignment: Alignment.centerLeft,
                    key: learning,
                    targetPadding: EdgeInsets.only(left: 20, right: 20, bottom: 25, top: 5),
                    title: Preferences.apptutor.learning?.title,
                    description: Preferences.apptutor.learning?.des ?? 'Learning is home page or dashboard',
                    // targetShapeBorder: const CircleBorder(),
                    tooltipActionConfig: const TooltipActionConfig(
                      alignment: MainAxisAlignment.spaceBetween,
                      actionGap: 16,
                      position: TooltipActionPosition.outside,
                      gapBetweenContentAndAction: 16,
                    ),
                    tooltipActions: [
                      tourPrevious(
                        context: context,
                      ),
                      tourNext(
                        context: context,
                      ),
                    ],
                    child: const Icon(Icons.local_library_outlined),
                  ),
                  label: Preferences.appString.learning ?? "Learning",
                ),
                BottomNavigationBarItem(
                  icon: Showcase(
                    titleTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    titleAlignment: Alignment.centerLeft,
                    key: coursebottom,
                    title: Preferences.apptutor.coursebottom?.title,
                    description: Preferences.apptutor.coursebottom?.des ?? 'Courses is course page',
                    targetPadding: EdgeInsets.only(left: 20, right: 20, bottom: 25, top: 5),
                    tooltipActionConfig: const TooltipActionConfig(
                      alignment: MainAxisAlignment.spaceBetween,
                      actionGap: 16,
                      position: TooltipActionPosition.outside,
                      gapBetweenContentAndAction: 16,
                    ),
                    tooltipActions: [
                      tourPrevious(
                        context: context,
                      ),
                      tourNext(
                        context: context,
                      ),
                    ],
                    child: const Icon(CupertinoIcons.book),
                  ),
                  label: Preferences.appString.courses ?? Languages.courses,
                ),
                BottomNavigationBarItem(
                  icon: Showcase(
                    titleTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    titleAlignment: Alignment.centerLeft,
                    key: feed,
                    title: Preferences.apptutor.feed?.title,
                    description: Preferences.apptutor.feed?.des ?? "Feed is notification page",
                    targetPadding: EdgeInsets.only(left: 20, right: 20, bottom: 25, top: 5),
                    tooltipActionConfig: const TooltipActionConfig(
                      alignment: MainAxisAlignment.spaceBetween,
                      actionGap: 16,
                      position: TooltipActionPosition.outside,
                      gapBetweenContentAndAction: 16,
                    ),
                    tooltipActions: [
                      tourPrevious(
                        context: context,
                      ),
                      tourNext(
                        context: context,
                      ),
                    ],
                    child: Icon(Icons.receipt_long),
                  ),
                  label: Preferences.appString.feed ?? "Feed",
                ),
                BottomNavigationBarItem(
                  icon: Showcase(
                    titleTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    titleAlignment: Alignment.centerLeft,
                    key: ebookbottom,
                    title: Preferences.apptutor.ebookbottom?.title,
                    description: Preferences.apptutor.ebookbottom?.des ?? "E-Books is e-book page",
                    targetPadding: EdgeInsets.only(left: 20, right: 20, bottom: 25, top: 5),
                    tooltipActionConfig: const TooltipActionConfig(
                      alignment: MainAxisAlignment.spaceBetween,
                      actionGap: 16,
                      position: TooltipActionPosition.outside,
                      gapBetweenContentAndAction: 16,
                    ),
                    tooltipActions: [
                      tourPrevious(
                        context: context,
                      ),
                      tourNext(
                        context: context,
                      ),
                    ],
                    child: const Icon(Icons.menu_book_rounded),
                  ),
                  label: Preferences.appString.ebook ?? "E-Books",
                ),
                BottomNavigationBarItem(
                  icon: Showcase(
                    titleTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    titleAlignment: Alignment.centerLeft,
                    key: storebottom,
                    title: Preferences.apptutor.storebottom?.title,
                    description: Preferences.apptutor.storebottom?.des ?? "Store is store page",
                    tooltipActionConfig: const TooltipActionConfig(
                      alignment: MainAxisAlignment.spaceBetween,
                      actionGap: 16,
                      position: TooltipActionPosition.outside,
                      gapBetweenContentAndAction: 16,
                    ),
                    tooltipActions: [
                      tourPrevious(
                        context: context,
                      ),
                      tourNext(
                          context: context,
                          onTap: () {
                            ShowCaseWidget.of(context).startShowCase([
                              homegroupFeature,
                              mycourse,
                              myDownloads,
                              myebooks,
                              library,
                            ]);
                          }),
                    ],
                    onBarrierClick: () async {
                      if (!SharedPreferenceHelper.getStringList(Preferences.showTour).contains(Preferences.homescreenTour)) {
                        ShowCaseWidget.of(context).startShowCase([
                          homegroupFeature,
                          mycourse,
                          myDownloads,
                          myebooks,
                          library,
                        ]);
                        SharedPreferenceHelper.setStringList(Preferences.showTour, SharedPreferenceHelper.getStringList(Preferences.showTour)..add(Preferences.homescreenTour));
                      }
                    },
                    targetPadding: EdgeInsets.only(left: 20, right: 20, bottom: 25, top: 5),
                    child: const Icon(Icons.shopping_cart_checkout_outlined),
                  ),
                  label: Preferences.appString.store ?? 'Store',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: ColorResources.buttoncolor,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onbackpress(BuildContext context) async {
    bool? exitApp = false;
    if (_selectedIndex == 0) {
      exitApp = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      Preferences.appString.exitAppConfirmation ?? Languages.areyousuretoexitthisApp,
                      style: GoogleFonts.notoSansDevanagari(
                        color: ColorResources.textblack,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              side: BorderSide(
                                width: 2,
                                color: ColorResources.textblack.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                Languages.no,
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorResources.buttoncolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                Languages.yes,
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ));
        },
      );
    } else {
      safeSetState(() {
        _selectedIndex = 0;
      });
    }
    return exitApp ?? false;
  }

  callApilogout() async {
    //Logout response;
    safeSetState(() {
      Preferences.onLoading(context);
    });
    try {
      // var token = SharedPreferenceHelper.getString(Preferences.access_token);

      SharedPreferenceHelper.clearPref();
      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } catch (error) {
      safeSetState(() {
        Preferences.hideDialog(context);
      });
      // print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
  }

  Future addresscheck(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.70,
        child: StatefulBuilder(
          builder: (context, safeSetState) {
            return const PincodeAddressUI();
          },
        ),
      ),
    );
  }

  void updatecheck() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Icon(
                      Icons.system_security_update,
                      color: ColorResources.buttoncolor,
                      size: 35,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    Preferences.appString.updateAvailable ?? "We recommend you to update this version and improved Learning Experience exiting features.",
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textblack,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorResources.buttoncolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (Platform.isAndroid) {
                                checkForUpdate();
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              "UPDATE",
                              style: TextStyle(color: ColorResources.textWhite),
                            )),
                      )
                    ],
                  )
                ],
              ),
            ));
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      // safeSetState(() {
      // _updateInfo = info;
      // });
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((e) {
          // showSnack(e.toString());
          return AppUpdateResult.inAppUpdateFailed;
        });
      }
    }).catchError((e) {
      // showSnack(e.toString());
    });
  }
}

class PincodeAddressUI extends StatefulWidget {
  const PincodeAddressUI({super.key});

  @override
  State<PincodeAddressUI> createState() => _PincodeAddressUIState();
}

class _PincodeAddressUIState extends State<PincodeAddressUI> {
  String address = SharedPreferenceHelper.getString(Preferences.address) ?? "";
  TextEditingController addressController = TextEditingController();
  PincodeModel pincodeModel = PincodeModel(postOffice: []);
  Future<PincodeModel> fetchdata() async {
    return pincodeModel;
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          'Select Your Address',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorResources.textblack,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: TextField(
            controller: addressController,
            onSubmitted: (value) async {
              FocusManager.instance.primaryFocus?.unfocus();
              Preferences.onLoading(context);
              pincodeModel = await RemoteDataSourceImpl().getAddressFromPincode(pincode: addressController.text).then((value) {
                Preferences.hideDialog(context);
                safeSetState(
                  () {},
                );
                return value;
              });
            },
            onChanged: (value) async {
              if (value.trim().length == 6) {
                FocusManager.instance.primaryFocus?.unfocus();
                Preferences.onLoading(context);
                pincodeModel = await RemoteDataSourceImpl().getAddressFromPincode(pincode: addressController.text).then((values) {
                  Preferences.hideDialog(context);
                  safeSetState(
                    () {},
                  );
                  return values;
                });
              }
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(Preferences.appString.enterPincode ?? "Enter PinCode"),
              hintText: "231652",
              suffixIcon: GestureDetector(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Preferences.onLoading(context);
                  pincodeModel = await RemoteDataSourceImpl().getAddressFromPincode(pincode: addressController.text).then((value) {
                    Preferences.hideDialog(context);
                    safeSetState(
                      () {},
                    );
                    return value;
                  });
                },
                child: const Icon(Icons.search),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        FutureBuilder(
          future: fetchdata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                //print(snapshot.data);
                //print(snapshot.data!.postOffice);
                //print(snapshot.data!.postOffice!.length);
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.postOffice!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String value = "${snapshot.data!.postOffice![index].name!} , ${snapshot.data!.postOffice![index].block!} , ${snapshot.data!.postOffice![index].district!} , ${snapshot.data!.postOffice![index].state!} , ${snapshot.data!.postOffice![index].pincode!}";
                        return RadioListTile(
                          title: Text(value),
                          value: value,
                          groupValue: address,
                          onChanged: (value) {
                            safeSetState(
                              () {
                                address = value!;
                              },
                            );
                          },
                        );
                      }),
                );
              } else {
                return Container();
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: address.trim().isEmpty || address == "N/A" ? Colors.grey : ColorResources.buttoncolor,
                  ),
                  onPressed: () {
                    if (address.trim().isEmpty || address == "N/A") {
                      flutterToast("Please select Address");
                    } else {
                      AuthDataSourceImpl().updateUserDetails(SharedPreferenceHelper.getString(Preferences.name)!, SharedPreferenceHelper.getString(Preferences.email)!, address).then((value) {
                        SharedPreferenceHelper.setString(Preferences.address, address);
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  child: const Text(
                    'Save ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600,
                      height: 0.13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RowButtonWidget extends StatelessWidget {
  final String icon;
  final String buttonTitle;
  final void Function()? onTap;
  final bool isNew;
  const RowButtonWidget({super.key, required this.icon, required this.buttonTitle, required this.onTap, required this.isNew});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Button Padding
        foregroundColor: ColorResources.textblack, // Text Color
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 0, bottom: 0, right: 0),
        child: Row(
          children: [
            Iconify(
              icon,
              size: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              buttonTitle,
              style: GoogleFonts.notoSansDevanagari(
                // fontWeight: FontWeight.w500,
                fontSize: 15,
                color: ColorResources.textblack,
              ),
            ),
            Spacer(),
            if (isNew) ...[
              Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: const Color(0xFFFCA004).withValues(alpha: 0.2),
                  ),
                  child: Text("New")),
              SizedBox(
                width: 10,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
