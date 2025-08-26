// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sd_campus_app/features/controller/auth_controller.dart';
// import 'package:sd_campus_app/features/cubit/auth/auth_cubit.dart';
// import 'package:sd_campus_app/util/color_resources.dart';
// import 'package:sd_campus_app/util/images_file.dart';
// import 'package:sd_campus_app/util/prefconstatnt.dart';
// import 'package:sd_campus_app/util/preference.dart';
// import 'package:sd_campus_app/view/screens/auth/mobile_number_screen.dart';
// import 'package:sd_campus_app/view/screens/auth/request_logout_screen.dart';
// import 'package:sd_campus_app/view/screens/auth/sign_in_screen.dart';
// import 'package:sd_campus_app/view/screens/contactus.dart';
// import 'package:sd_campus_app/view/screens/home.dart';

// class AuthHomeScreen extends StatefulWidget {
//   const AuthHomeScreen({super.key});

//   @override
//   State<AuthHomeScreen> createState() => _AuthHomeScreenState();
// }

// class _AuthHomeScreenState extends State<AuthHomeScreen> {
//   List<Widget> bannerList = [];
//   late Future<List<Widget>> getBanner;
//   @override
//   void initState() {
//     getBanner = AuthController().getBanner();
//     super.initState();
//   }

//   void sendlog() async {
//     Preferences.facebookAppEvents.logViewContent(id: await Preferences.facesbookanonymousid, content: {
//       "datatime": DateTime.now(),
//       "place": "authhomescreen"
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: BlocConsumer<AuthCubit, AuthState>(
//       listener: (context, state) {
//         // TODO: implement listener
//         // print(state);
//         if (state is LoadingAuth) {
//           Preferences.onLoading(context);
//         }
//         if (state is ErrorSnackbar) {
//           Preferences.hideDialog(context);
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               backgroundColor: ColorResources.buttoncolor,
//               margin: const EdgeInsets.all(8.0),
//               behavior: SnackBarBehavior.floating,
//               content: Row(
//                 children: [
//                   Icon(
//                     Icons.info_outline_rounded,
//                     color: ColorResources.textWhite,
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Expanded(
//                     child: Text(
//                       state.msg,
//                       style: TextStyle(
//                         color: ColorResources.textWhite,
//                       ),
//                     ),
//                   )
//                 ],
//               )));
//         }

//         if (state is ErrorAuth) {
//           Preferences.hideDialog(context);
//         }
//         if (state is GoogleAuthRequestToLogout) {
//           Preferences.hideDialog(context);
//           Navigator.push(
//             context,
//             CupertinoPageRoute(
//               builder: (context) => RequestLogoutScreen(
//                 userEmail: state.email,
//                 bannerList: bannerList,
//               ),
//             ),
//           );
//         }
//         if (state is GoogleSuccess) {
//           // print(state);
//           Preferences.hideDialog(context);
//           SharedPreferenceHelper.setBoolean(Preferences.isloggedin, true);
//           SharedPreferenceHelper.setString(Preferences.dateoflogin, DateTime.now().toString().split(' ')[0]);
//           Navigator.pushReplacement(
//               context,
//               CupertinoPageRoute(
//                 builder: (context) => const HomeScreen(),
//               ));
//         }
//         if (state is GooglePhoneNumberVerification) {
//           Preferences.hideDialog(context);
//           // print(state);
//           Navigator.push(
//             context,
//             CupertinoPageRoute(
//               builder: (context) => MobileNumberScreen(images: bannerList),
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         return SafeArea(
//           child: Column(children: [
//             // FutureBuilder<List<Widget>>(
//             //     future: getBanner,
//             //     builder: (context, snapshots) {
//             //       if (snapshots.connectionState == ConnectionState.done) {
//             //         if (snapshots.hasData) {
//             //           return CarouselSlider(
//             //             items: snapshots.data,
//             //             options: CarouselOptions(
//             //               viewportFraction: 1,
//             //               initialPage: 0,
//             //               enableInfiniteScroll: true,
//             //               reverse: false,
//             //               autoPlay: true,
//             //               autoPlayInterval: const Duration(seconds: 3),
//             //               autoPlayAnimationDuration: const Duration(milliseconds: 800),
//             //               autoPlayCurve: Curves.fastOutSlowIn,
//             //               enlargeCenterPage: true,
//             //               scrollDirection: Axis.horizontal,
//             //             ),
//             //           );
//             //         } else if (snapshots.hasError) {}
//             //         return const Text('Something went wrong');
//             //       } else {
//             //         return const Center();
//             //       }
//             //     }),
//             CustomPaint(
//               painter: MyPainter(),
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height * 0.4,
//                 child: Center(
//                   child: Image.asset(
//                     SvgImages.logo,
//                     height: 150,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Expanded(
//               child: FractionallySizedBox(
//                 widthFactor: 0.65,
//                 child: Column(
//                   children: [
//                     const SizedBox(
//                       height: 50,
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               'Welcome To SD campus',
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.notoSansDevanagari(
//                                 color: const ColorResources.textblack,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600,
//                                 height: 0,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 70,
//                             ),
//                             // Spacer(),
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) => const SignInScreen(),
//                                 ));
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
//                                 decoration: ShapeDecoration(
//                                   color: ColorResources.buttoncolor,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Image.network(
//                                       SvgImages.authemail,
//                                       height: 30,
//                                     ),
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                     Text(
//                                       'Continue with Email',
//                                       style: GoogleFonts.notoSansDevanagari(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500,
//                                         height: 0,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 BlocProvider.of<AuthCubit>(context).googleAuth();
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
//                                 decoration: ShapeDecoration(
//                                   color: ColorResources.textWhite,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   shadows: const [
//                                     BoxShadow(
//                                       color: Color(0xBFD9D9D9),
//                                       blurRadius: 50,
//                                       offset: Offset(0, 4),
//                                       spreadRadius: 0,
//                                     )
//                                   ],
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Image.network(
//                                       SvgImages.google,
//                                       height: 30,
//                                     ),
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                     Text(
//                                       'Continue with Google',
//                                       style: GoogleFonts.notoSansDevanagari(
//                                         color: const ColorResources.textblack,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500,
//                                         height: 0,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const Spacer(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ]),
//         );
//       },
//     ));
//   }
// }
