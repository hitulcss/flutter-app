// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sd_campus_app/features/cubit/auth/auth_cubit.dart';
// import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
// import 'package:sd_campus_app/util/color_resources.dart';
// import 'package:sd_campus_app/util/prefconstatnt.dart';
// import 'package:sd_campus_app/view/screens/auth/otp_verification_screen.dart';

// class MobileNumberScreen extends StatelessWidget {
//   const MobileNumberScreen({super.key, required this.images});
//   final List<Widget> images;

//   @override
//   Widget build(BuildContext context) {
//     String mobileNumber = '';
//     return Scaffold(
//         body: BlocConsumer<AuthCubit, AuthState>(
//       listener: (context, state) {
//         if (state is GoogleAddPhoneNumberLoading) {
//           Preferences.onLoading(context);
//         }
//         if (state is GoogleAddPhonenumber) {
//           Preferences.hideDialog(context);
//           Navigator.push(
//             context,
//             CupertinoPageRoute(
//               builder: (context) => OtpVerificationScreen(
//                 bannerList: images,
//                 userNumber: mobileNumber,
//               ),
//             ),
//           );
//         }
//         if (state is GoogleAddPhonenumberError) {
//           Preferences.hideDialog(context);
//         }
//       },
//       builder: (context, state) {
//         return Container(
//           constraints: const BoxConstraints(
//             maxWidth: 600,
//           ),
//           child: Column(
//             children: [
//               CarouselSlider(
//                 items: images,
//                 options: CarouselOptions(
//                   viewportFraction: 1,
//                   initialPage: 0,
//                   enableInfiniteScroll: true,
//                   reverse: false,
//                   autoPlay: true,
//                   autoPlayInterval: const Duration(seconds: 3),
//                   autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                   autoPlayCurve: Curves.fastOutSlowIn,
//                   enlargeCenterPage: true,
//                   scrollDirection: Axis.horizontal,
//                 ),
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               Center(
//                 child: Text(
//                   'Add Your Phone Number',
//                   style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.w900, fontSize: 24),
//                 ),
//               ),
//               const SizedBox(
//                 height: 45,
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
//                 child: 
                
//                 TextField(
//                   onChanged: (value) {
//                     mobileNumber = value;
//                   },
//                   keyboardType: TextInputType.number,
//                   style: GoogleFonts.notoSansDevanagari(fontSize: 20),
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.blueAccent, width: 32.0),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     labelText: 'Mobile No.',
//                   ),
//                 ),
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.50,
//                 margin: const EdgeInsets.symmetric(vertical: 35),
//                 decoration: BoxDecoration(color: ColorResources.buttoncolor, borderRadius: BorderRadius.circular(14)),
//                 child: TextButton(
//                   onPressed: () {
//                     if (mobileNumber.length == 10) {
//                       BlocProvider.of<AuthCubit>(context).goolgePhoneNumberAdd(mobileNumber);
//                     } else {
//                       flutterToast('Enter the valid Number');
//                     }
//                   },
//                   child: Text(
//                     'Register Phone',
//                     style: GoogleFonts.notoSansDevanagari(
//                       color: ColorResources.textWhite,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     ));
//   }
// }
