// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:in_app_review/in_app_review.dart';
import 'package:connectivity_plus/connectivity_plus.dart' show Connectivity, ConnectivityResult;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sd_campus_app/features/data/remote/models/alertmodel.dart';
import 'package:sd_campus_app/features/data/remote/models/app_string.dart';
import 'package:sd_campus_app/features/data/remote/models/app_tour.dart';
import 'package:sd_campus_app/features/data/remote/models/features.dart';
import 'package:sd_campus_app/features/data/remote/models/scholarship_guidance.dart';
import 'package:sd_campus_app/features/data/remote/models/tutor_video.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/models/new_features.dart';
import 'package:sd_campus_app/util/preference.dart';
// import 'package:gtm/gtm.dart';
import 'package:no_screenshot/no_screenshot.dart';

class Preferences {
  Preferences._();

  static const String isloggedin = "isLoggedIn";
  static const String isnewUser = "isnewUser";
  static const String isNameAdded = "isNameAdded";
  static const String isStreamAdded = "isStreamAdded";
  static const String isVerified = "isVerified";
  static const String name = "name";
  static const String userid = "userid";
  static const String authtoken = "authToken";
  static const String accesstoken = "accessToken";
  static const String passwordchangedata = "Passwordchangedata";
  static const String language = 'language';
  static const String course = 'course';
  static const String email = 'email';
  static const String phoneNUmber = 'phoneNUmber';
  static const String profileImage = 'profileImage';
  static const String address = 'address';
  static const String timerisset = 'timerisset';
  static const String alarmname = 'alarmname';
  static const String alarmtime = 'alarmtime';
  static const String selectedtimename = 'selectedtimename';
  static const String alarmtimeinsec = 'alarmtimeinsec';
  static const String googleaccesstoken = "googleaccesstoken";
  static const String otphitcount = 'otphitcount';
  static const String otpexptime = 'otpexptime';
  static const String dateoflogin = 'dateoflogin';
  static const String enrollId = 'enrollId';
  static const String getStreams = 'getStreams';
  static const String getStreamsApi = 'getStreamsApi';
  static const String selectedStream = 'selectedStream';
  static const String myReferralCode = 'myReferralCode';
  static const String usercoins = 'usercoins';
  //api
  static const String getMyCourse = 'getMyCourse';
  static const String getCourse = 'getCourse';
  static const String getTestSeries = 'getTestSeries';
  static const String getReferalContent = 'getReferalContent';
  static const String getmywallet = 'getmywallet';
  static const String awareness = 'awareness';
  static const String getAllEbookApi = "getAllEbookApi";
  static const String getallFeedApi = "getallFeedApi";
  static const String demoClosed = "demoClosed";
  static const String demoLink = "demoLink";
  static const String showTour = "showTour";
  static const String homeTour = "homeTour";
  static const String homescreenTour = "homescreenTour";
  static const String courseScreenTour = "courseScreenTour";
  static const String classYTTour = "classYTTour";
  static const String classTwoWayTour = "classTwoWayTour";
  static const String lectureTabCourseScreenTour = "lectureTabCourseScreenTour";
  static const String lectureVideoYtTour = "lectureVideoYtTour";
  static const String lectureVideotwoWayTour = "lectureVideotwoWayTour";
  static const String showTourDoubt = "showTourDoubt";
  static const String showTourCommunity = "showTourCommunity";
  static const String showTourLibrary = "showTourLibrary";

  // static Gtm gtm = Gtm.instance;
  static FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  //remotconfig
  static Map<String, dynamic> remoteSocial = json.decode(
    remoteConfig.getValue("social_media").asString(),
  );
  static Map<String, dynamic> remoteStore = json.decode(
    remoteConfig.getValue("store").asString(),
  );
  static Map<String, dynamic> remoteAppInfo = json.decode(
    remoteConfig.getValue("app_info").asString(),
  );
  static Map<String, dynamic> awareApp = json.decode(
    remoteConfig.getValue("aware_app").asString(),
  );
  static Map<String, dynamic> remoteImageUrls = json.decode(
    remoteConfig.getValue("image_urls").asString(),
  );
  static Map<String, dynamic> remoteReferAndEarn = json.decode(
    remoteConfig.getValue("refer_and_earn").asString(),
  );
  static List<AlertModelData> appAlerts = json.decode(remoteConfig.getValue("alerts").asString()).runtimeType == List ? (jsonDecode(remoteConfig.getValue("alerts").asString()) as List).map((e) => AlertModelData.fromJson(e)).toList() : [];
  static String remoteTermsConditions = remoteConfig.getValue("termsConditions").asString();
  static String remotePrivacyPolicy = remoteConfig.getValue("privacyPolicy").asString();
  static String remoteNewPolicy = remoteConfig.getValue("new_policy").asString();
  static List<Scholarshipguidance> remotescholarshipguidance = json.decode(remoteConfig.getValue("scolarshipGuidelines").asString()).runtimeType == List ? (jsonDecode(remoteConfig.getValue("scolarshipGuidelines").asString()) as List).map((e) => Scholarshipguidance.fromMap(e)).toList() : [];
  static List<Sidebar> remoteFutureSidebar = Features.fromMap(jsonDecode(remoteConfig.getValue("features").asString())).sidebar?.where((element) => element.isEnabled == true).toList() ?? [];
  static AppStrings appString = AppStrings.fromJson(json.decode(
    remoteConfig.getValue("app_strings").asString(),
  ));
  static NewFeatures newFeatures = NewFeatures.fromMap(json.decode(remoteConfig.getValue("newFeatures").asString()));
  static TutorVideo tutorVideo = TutorVideo.fromMap(json.decode(remoteConfig.getValue("tutorvideo").asString()));
  static AppTour apptutor = AppTour.fromMap(json.decode(remoteConfig.getValue("appTour").asString()));
  static hideDialog(BuildContext context) {
    Navigator.canPop(context) ? Navigator.pop(context) : null;
  }

  static Future awarenessPopup(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(Preferences.awareApp["title"]),
              content: Text(Preferences.awareApp["desc"]),
              actions: [
                TextButton(
                  onPressed: () {
                    SharedPreferenceHelper.setBoolean(Preferences.awareness, true);
                    Navigator.pop(context);
                  },
                  child: const Text('Got it'),
                ),
              ],
            ));
  }

  static FirebaseInAppMessaging inAppMessaging = FirebaseInAppMessaging.instance;
  static final facebookAppEvents = FacebookAppEvents();
  static Future<String?> facesbookanonymousid = facebookAppEvents.getAnonymousId();
  static final InAppReview inAppReview = InAppReview.instance;

  static Future<bool> checkNetwork() async {
    final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    }
  }

  static onLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Please Wait..."),
              ],
            ),
          ),
        );
      },
    );
  }

  static void toggleScreenshot() async {
    final noScreenshot = NoScreenshot.instance;
    if (SharedPreferenceHelper.getString(Preferences.email)!.contains('@sdempire.co.in')) {
      bool result = await noScreenshot.screenshotOn();
      debugPrint('Toggle Screenshot: $result');
    } else {
      bool result = await noScreenshot.screenshotOff();
      debugPrint('Toggle Screenshot: $result');
    }
  }

  static Future<bool> checkStoragePermission() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if ((info.version.sdkInt) >= 33) {
        // status = await Permission.manageExternalStorage.request();
        return true;
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.storage.request();
    }

    switch (status) {
      case PermissionStatus.denied:
        return false;
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.restricted:
        return false;
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.permanentlyDenied:
        return false;
      case PermissionStatus.provisional:
        return true;
    }
  }

  /// Function to check and request location permission.
  ///
  /// This function requests the location permission using the `permission_handler` package.
  /// It handles different permission statuses and shows a pop-up to guide the user to
  /// open the app settings if needed.
  ///
  /// Returns `true` if the location permission is granted, otherwise `false`.
//   static Future<bool> checkLocationPermission(BuildContext context) async {
//     // Request location permission
//     PermissionStatus status = await Permission.location.request();

//     // Handle the permission status
//     switch (status) {
//       case PermissionStatus.denied:
//       case PermissionStatus.permanentlyDenied:
//         // Show a pop-up asking the user to grant location permission
//         await showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Location Permission'),
//             content: const Text('If you denied this permission, you cannot use this feature. Please turn on permission at [App Setting] > [Permission]'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   Navigator.of(context).pop(true);
//                   // Open the app settings
//                   await openAppSettings();
//                 },
//                 child: const Text('SETTING'),
//               ),
//             ],
//           ),
//         );
//         return false;
//       case PermissionStatus.granted:
//       case PermissionStatus.limited:
//       case PermissionStatus.provisional:
//         return true; // Permission granted

//       case PermissionStatus.restricted:
//         return false; // Location access is restricted
//     }
//   }
}
