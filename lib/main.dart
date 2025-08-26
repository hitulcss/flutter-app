import 'dart:async';
import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sd_campus_app/api/api.dart';
import 'package:sd_campus_app/features/cubit/auth/auth_cubit.dart';
import 'package:sd_campus_app/features/cubit/cart/cart_cubit.dart';
import 'package:sd_campus_app/features/cubit/coins/coin_cubit.dart';
import 'package:sd_campus_app/features/cubit/coupon/coupon_cubit.dart';
import 'package:sd_campus_app/features/cubit/course_filter/coursefilter_cubit.dart';
import 'package:sd_campus_app/features/cubit/course_plan/plan_cubit.dart';
import 'package:sd_campus_app/features/cubit/hometimer/hometimer_cubit.dart';
import 'package:sd_campus_app/features/cubit/live_Stream_quiz/livestream_quiz_cubit.dart';
import 'package:sd_campus_app/features/cubit/mediasoup/mediasoup_cubit.dart';
import 'package:sd_campus_app/features/cubit/quiz/quiz_cubit.dart';
import 'package:sd_campus_app/features/cubit/quiz_library/quiz_library_cubit.dart';
import 'package:sd_campus_app/features/cubit/storeAddress/StoreAddress_cubit.dart';
import 'package:sd_campus_app/features/cubit/streamselect/streamsetect_cubit.dart';
import 'package:sd_campus_app/features/cubit/youtubeStream_cubit/youtubestreamcubit_cubit.dart';
import 'package:sd_campus_app/features/cubit/youtubevideo_cubit/youtubevideo_cubit.dart';
import 'package:sd_campus_app/features/presentation/bloc/api_bloc/api_bloc.dart';
import 'package:sd_campus_app/features/presentation/bloc/batch_community/batch_community_bloc.dart';
import 'package:sd_campus_app/features/presentation/bloc/batch_doubt/batch_doubt_bloc.dart';
import 'package:sd_campus_app/features/services/notification.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/util/remote_data.dart';
import 'package:sd_campus_app/util/theme.dart';
import 'package:sd_campus_app/view/screens/auth/name_screen.dart';
import 'package:sd_campus_app/view/screens/auth/sign_in_screen.dart';
import 'package:sd_campus_app/view/screens/bottomnav/coursescreen.dart';
import 'package:sd_campus_app/view/screens/bottomnav/editprofile.dart';
import 'package:sd_campus_app/view/screens/bottomnav/ncert.dart';
import 'package:sd_campus_app/view/screens/bottomnav/profile.dart';
import 'package:sd_campus_app/view/screens/contactus.dart';
import 'package:sd_campus_app/view/screens/exam_category.dart';
import 'package:sd_campus_app/view/screens/home.dart';
import 'package:sd_campus_app/view/screens/notifications.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/course_index_resources.dart';
import 'package:sd_campus_app/view/screens/sidenav/aboutus.dart';
import 'package:sd_campus_app/view/screens/sidenav/download.dart';
import 'package:sd_campus_app/view/screens/sidenav/helpandsupport.dart';
import 'package:sd_campus_app/view/screens/sidenav/mycourses.dart';
import 'package:sd_campus_app/view/screens/sidenav/myorders.dart';
import 'package:sd_campus_app/view/screens/sidenav/myschedule.dart';
import 'package:sd_campus_app/view/screens/sidenav/myscheduleadd.dart';
import 'package:sd_campus_app/view/screens/sidenav/mytest.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/airresourcesscreen.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/dailynews.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/samplenotes.dart';
import 'package:sd_campus_app/view/screens/sidenav/resources/shortnotes.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sd_campus_app/firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:sd_campus_app/view/screens/store/store_home.dart';
import 'package:showcaseview/showcaseview.dart';
//import 'package:workmanager/workmanager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
final FirebaseAnalyticsObserver analyticsObserver = FirebaseAnalyticsObserver(analytics: analytics);

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // analytics.setAnalyticsCollectionEnabled(true);
  // print("object*" * 20000);
  // print('A bg message just showed up :  ${message.messageId}');
  // RemoteNotification? notification = message.notification;
  // AndroidNotification? android = message.notification?.android;
  // if (notification != null && android != null) {
  //   //print(notification.title);
  //   flutterLocalNotificationsPlugin.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(channel.id, channel.name,
  //             channelDescription: channel.description,
  //             color: Colors.blue,
  //             playSound: true,
  //             icon: 'mipmap/ic_launcher',
  //             styleInformation: BigTextStyleInformation(
  //               notification.body!,
  //               summaryText: notification.title,
  //               contentTitle: notification.body,
  //               htmlFormatContent: true,
  //               htmlFormatBigText: true,
  //               htmlFormatContentTitle: true,
  //               htmlFormatSummaryText: true,
  //               htmlFormatTitle: true,
  //             )),
  //       ));
  // }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'SDCampusAPPNotication', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
  enableLights: true,
  playSound: true,
);

Future<void> main() async {
  //Orientations
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  await SharedPreferenceHelper.init();
  // firebase in app messaging
  Preferences.inAppMessaging.setAutomaticDataCollectionEnabled(true);
  // firebase remote config
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(minutes: 5),
  ));
  await remoteConfig.setDefaults(remote_data);
  await remoteConfig.ensureInitialized();
  // print(remoteConfig.lastFetchTime);
  // print(remoteConfig.getValue("test_json"));
  // firebase crashlytics and firebase feching remote config
  Preferences.checkNetwork().then((value) async {
    if (value == true) {
      await remoteConfig.fetchAndActivate();
      if (kReleaseMode && Apis.rootUrl != "https://stage-backend.sdcampus.com") {
        crashlytics.setCrashlyticsCollectionEnabled(true);
        crashlytics.setCrashlyticsCollectionEnabled(true);
        FlutterError.onError = (errorDetails) {
          crashlytics.recordFlutterFatalError(errorDetails);
        };
        // crashlytics.log('App started successfully');
        // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
        PlatformDispatcher.instance.onError = (error, stack) {
          crashlytics.recordError(
            error,
            stack,
            fatal: true,
            printDetails: true,
            information: [
              SharedPreferenceHelper.getString(Preferences.accesstoken) ?? "",
              SharedPreferenceHelper.getString(Preferences.name) ?? "",
              SharedPreferenceHelper.getString(Preferences.phoneNUmber) ?? "",
              SharedPreferenceHelper.getString(Preferences.isloggedin) ?? "",
              Preferences.checkNetwork(),
              SharedPreferenceHelper.getString(Preferences.email) ?? "",
              SharedPreferenceHelper.getString(Preferences.userid) ?? "",
              SharedPreferenceHelper.getString(Preferences.enrollId) ?? "",
            ],
          );
          return true;
        };
      }
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FlutterDownloader.initialize(
      debug: true,
      // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
      );

  await firebaseMessaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  Preferences.toggleScreenshot();
  // SharedPreferenceHelper.getString(Preferences.email)!.contains('@sdempire.co.in') ? print('done') : FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]).then(
    (_) async {
      initNotifications();
      //Languages.isEnglish = SharedPreferenceHelper.getString(Preferences.language)! == "English" ? false : true;
      await Languages.initState();
      // print(await firebaseMessaging.getToken());
      runApp(
        DevicePreview(
          enabled: !kReleaseMode,
          builder: (context) => ShowCaseWidget(
              enableAutoScroll: true,
              builder: (context) {
                return const MyApp();
              }),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ResourceDataSourceImpl resourceDataSourceImpl = ResourceDataSourceImpl();
    // RemoteDataSourceImpl remoteDataSourceImpl = RemoteDataSourceImpl();
    // Workmanager().initialize(
    //   callbackDispatcher,
    //   isInDebugMode: true,
    // );
    return SafeArea(
      top: false,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ApiBloc(),
          ),
          BlocProvider(
            create: (context) => HometimerCubit(),
          ),
          BlocProvider(
            create: (context) => AuthCubit(),
          ),
          BlocProvider(
            create: (context) => QuizCubit(),
          ),
          BlocProvider(
            create: (context) => QuizLibraryCubit(),
          ),
          BlocProvider(
            create: (context) => CouponCubit(),
          ),
          BlocProvider(
            create: (context) => StreamsetectCubit(),
          ),
          BlocProvider(
            create: (context) => CoursefilterCubit(),
          ),
          BlocProvider(
            create: (context) => CoinCubit(),
          ),
          BlocProvider(
            create: (context) => CartCubit(),
          ),
          BlocProvider(
            create: (context) => StoreAddressCubit(),
          ),
          BlocProvider(
            create: (context) => MediasoupCubit(),
          ),
          BlocProvider(create: (context) => LivestreamQuizCubit()),
          BlocProvider(create: (context) => YoutubeStreamCubit()),
          BlocProvider(create: (context) => YoutubeVideoCubit()),
          BlocProvider(create: (context) => BatchDoubtBloc()),
          BlocProvider(create: (context) => BatchCommunityBloc()),
          BlocProvider(create: (context) => CoursePlanCubit()),
        ],
        child: MaterialApp(
          title: 'SD Campus',
          debugShowCheckedModeBanner: false,
          // builder: (context, widget) {
          // Widget error = const Text('...rendering error...');
          //   ErrorWidget.builder = (errorDetails) => Center(
          //           child: Text(
          //         errorDetails.exception.toString(),
          // errorDetails.library!,
          //       ));
          //   if (widget is Scaffold || widget is Navigator) {
          //     Center(child: Text('screen or Navigator'));
          //   }
          //   if (widget != null) return widget;
          //   throw ('widget is null');
          // },
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          theme: AppTheme().getThemeData(),
          // ThemeData(
          //   scaffoldBackgroundColor: const Color(0xFFF2EBFF),
          //   visualDensity: VisualDensity.adaptivePlatformDensity,
          //   // useMaterial3: false,
          //   appBarTheme: AppBarTheme(
          //     color: ColorResources.telegarm,
          //     surfaceTintColor: Colors.white,
          //   ),
          //   primarySwatch: Colors.purple,
          //   textTheme: GoogleFonts.notoSansDevanagariTextTheme(),
          // ),
          //home: const Splash(),
          navigatorKey: navigatorKey,
          initialRoute: '/',
          routes: {
            '/': (context) => const Splash(),
            'home': (context) => const HomeScreen(),
            // 'SignIn': (context) => const loginscreen(), //SignIn(),
            // 'SignUp': (context) => const SignUp(),
            // 'otpverification': (context) => Otpverification(
            //       number: '',
            //     ),
            // 'languagescreen': (context) => const LanguageScreen(
            //       isLogin: false,
            //     ),
            'notifications': (context) => const NotificationScreen(),
            // 'homescreen': (context) => const HomeScreens(),
            'Coursescreen': (context) => const CourseScreen(),
            // 'mocktestscreen': (context) => Mocktestscreen(
            //       remoteDataSourceImpl: remoteDataSourceImpl,
            //     ),
            'ProfilScreen': (context) => const ProfilScreen(),
            'editprofilescreen': (context) => const EditProfileScreen(),
            'downloadScreen': (context) => const DownloadScreen(),
            'resourcesscreen': (context) => const ResourcesScreen(),
            // 'cartscreen': (context) => const CartScreen(),
            'mycoursesscreen': (context) => const MyCoursesScreen(),
            'mytestseries': (context) => const TestSeries(
                  id: "",
                ),
            //'ourachievements': (context) => const OurAchievementsScreen(),
            'myordersscreen': (context) => const MyOrdersScreen(),
            'helpandsupport': (context) => const HelpAndSupport(),
            // 'forgotpasswordscreen': (context) => const ForgotPasswordScreen(),
            // 'passwordotp': (context) => PasswordOtp(
            //       Otpfor: '',
            //     ),

            // 'passwordverified': (context) => passwordVerified(
            //       type: '',
            //     ),
            // 'passwordchange': (context) => const PasswordChange(),
            'ncertscreen': (context) => const NcertScreen(),
            'MySchedule': (context) => const MySchedule(),
            'MyScheduleAdd': (context) => const MyScheduleAdd(),
            'dailynews': (context) => const DailyNewsScreen(),
            'shortnotes': (context) => const ShortNotesScreen(),
            'courseIndex': (context) => const CoursesIndexResources(),
            // 'youtubenotes': (context) => const YoutubeNotesScreen(),
            'samplenotes': (context) => const SampleNotesScreen(),
            'airResources': (context) => const AirResourcesScreen(),
            'contactus': (context) => const ContactUsScreen(),
            'aboutusscreen': (context) => const AboutUsScreen(),
            "store": (context) => const StoreHomeScreen()
            //           'joinstreaming': (context) => const JoinStreamingScreen(
            // lecture: '',
            //                 rtctoken: '',
            //                 rtmtoken: '',
            //                 uid: 0,
            //               ),
          },
        ),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  AppUpdateInfo? _updateInfo;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    Preferences.checkNetwork().then((value) {
      if (value) {
        remoteConfig.fetchAndActivate();
      }
    });
    // Preferences.gtm.push(
    //   'test',
    //   parameters: {
    //     'user_no': 912342,
    //   },
    // );
    Permission.notification.request();
    analytics.logAppOpen(callOptions: AnalyticsCallOptions(global: true), parameters: {
      "name": SharedPreferenceHelper.getString(Preferences.name) ?? "Unknown",
      "phoneNumber": SharedPreferenceHelper.getString(Preferences.phoneNUmber) ?? "Unknown",
      "email": SharedPreferenceHelper.getString(Preferences.email) ?? "Unknown",
      "id": SharedPreferenceHelper.getString(Preferences.enrollId) ?? analytics.getSessionId().toString(),
    });
    if (SharedPreferenceHelper.getString(Preferences.dateoflogin) != 'N/A') {
      if (DateTime.now().difference(DateTime.parse(SharedPreferenceHelper.getString(Preferences.dateoflogin)!)).inDays > 15) {
        SharedPreferenceHelper.clearPref();
      }
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print("message recieved on message method");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        //print(notification.title);
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id, channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                priority: Priority.max,
                icon: '@mipmap/ic_launcher',
                // styleInformation: BigTextStyleInformation(
                //   notification.title!,
                //   contentTitle: notification.title,
                //   summaryText: notification.body,
                //   htmlFormatContent: true,
                //   htmlFormatBigText: true,
                //   htmlFormatContentTitle: true,
                //   htmlFormatSummaryText: true,
                //   htmlFormatTitle: true,
                // ),
              ),
            ));
      }
    });
    SharedPreferenceHelper.setBoolean(Preferences.isNameAdded, SharedPreferenceHelper.getString(Preferences.name) != "N/A" && SharedPreferenceHelper.getString(Preferences.name)!.trim().isEmpty && SharedPreferenceHelper.getString(Preferences.name)!.trim() != "Name" ? false : true);
    if (Platform.isAndroid) {
      checkForUpdate();
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
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

  // void showSnack(String text) {
  //   if (_scaffoldKey.currentContext != null) {
  //     // ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // print(SharedPreferenceHelper.getBoolean(Preferences.isNameAdded) && SharedPreferenceHelper.getBoolean(Preferences.isStreamAdded));
    // print(SharedPreferenceHelper.getBoolean(Preferences.isNameAdded));
    // print(SharedPreferenceHelper.getBoolean(Preferences.isStreamAdded));
    // print(SharedPreferenceHelper.getBoolean(Preferences.isloggedin));
    return Semantics(
      label: "splach screen",
      child: Scaffold(
        key: _scaffoldKey,
        body: EasySplashScreen(
          navigator: !SharedPreferenceHelper.getBoolean(Preferences.isloggedin)
              ? const SignInScreen()
              : (SharedPreferenceHelper.getString(Preferences.accesstoken) == 'N/A' || SharedPreferenceHelper.getString(Preferences.dateoflogin) == 'N/A')
                  ? const SignInScreen()
                  : DateTime.now().difference(DateTime.parse(SharedPreferenceHelper.getString(Preferences.dateoflogin)!)).inDays >= 15
                      ? const SignInScreen()
                      : SharedPreferenceHelper.getBoolean(Preferences.isNameAdded) && SharedPreferenceHelper.getBoolean(Preferences.isStreamAdded)
                          ? const HomeScreen()
                          : SharedPreferenceHelper.getBoolean(Preferences.isNameAdded)
                              ? const ExamCategoryScreen()
                              : NameScreen(
                                  tohome: SharedPreferenceHelper.getStringList(Preferences.course).isNotEmpty,
                                ),
          durationInSeconds: 1,
          logoWidth: MediaQuery.of(context).size.width / 2,
          showLoader: false,
          logo: Image.network(
            SvgImages.aboutLogo,
            loadingBuilder: (context, child, loadingProgress) => const Center(child: CircularProgressIndicator()),
            errorBuilder: (context, url, error) => Image.asset(
              SvgImages.logo,
              height: 200,
            ),
          ),
          backgroundImage: const AssetImage(
            "assets/images/splashscreen_bg.png",
          ),
          backgroundColor: Colors.white,
          //text: 'Civil Service for Nation Building',
        ),
      ),
    );
  }
}
