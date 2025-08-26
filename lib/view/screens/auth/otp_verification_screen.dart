import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:sd_campus_app/features/cubit/auth/auth_cubit.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/auth/name_screen.dart';
import 'package:sd_campus_app/view/screens/auth/otptimer.dart';
import 'package:sd_campus_app/view/screens/home.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.bannerList,
    required this.userNumber,
    required this.optlength,
  });
  final int optlength;
  final List<Widget> bannerList;
  final String userNumber;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool showError = false;
  String otp = '';
  int otpCountap = 0;

  int length = 0;
  static const borderColor = Color.fromRGBO(114, 178, 238, 1);
  static const errorColor = Color.fromRGBO(255, 234, 238, 1);
  static const fillColor = Color.fromRGBO(255, 255, 255, 0.569);

  final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: GoogleFonts.notoSansDevanagari(
      fontSize: 22,
      color: const Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      color: fillColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: ColorResources.borderColor),
    ),
  );
  @override
  void initState() {
    length = widget.optlength;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (focusNode.canRequestFocus) {
        focusNode.requestFocus();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          otpCountap = SharedPreferenceHelper.getInt(Preferences.otphitcount);
          // print('-----------------Otp Verification Screen-------------');
          // print(state);
          if (state is VerificationOtpLoading) {
            Preferences.onLoading(context);
          }
          if (state is VerificationOtpSuccess) {
            Preferences.hideDialog(context);
            // SharedPreferenceHelper.setBoolean(Preferences.isNameAdded, state.newUser?false:true);
            // SharedPreferenceHelper.setBoolean(Preferences.isStreamAdded, state.newUser?false:true);
            if (state.newUser || SharedPreferenceHelper.getString(Preferences.name)!.trim().isEmpty) {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (context) => NameScreen(
                          tohome: SharedPreferenceHelper.getStringList(Preferences.course).isEmpty ? false : true,
                        )),
              );
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                  (route) => false);
            }
          }
          if (state is VerificationOtpError || state is ResendOtpSuccess) {
            Preferences.hideDialog(context);
            Preferences.hideDialog(context);
            Preferences.hideDialog(context);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // CarouselSlider(
                  //   items: widget.bannerList,
                  //   options: CarouselOptions(
                  //     height: 250,
                  //     initialPage: 0,
                  //     enableInfiniteScroll: true,
                  //     autoPlay: true,
                  //     autoPlayInterval: const Duration(seconds: 3),
                  //     autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  //     autoPlayCurve: Curves.fastOutSlowIn,
                  //     enlargeCenterPage: true,
                  //     scrollDirection: Axis.horizontal,
                  //   ),
                  // ),
                  CachedNetworkImage(
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    imageUrl: SvgImages.otpscreen,
                    height: 250,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'OTP sent on',
                        style: GoogleFonts.notoSansDevanagari(
                          color: ColorResources.textblack,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '+91-${widget.userNumber} ',
                              style: GoogleFonts.notoSansDevanagari(fontSize: 21),
                            ),
                            Iconify(
                              "<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' aria-hidden='true' role='img' class='iconify iconify--lucide' width='1em' height='1em' preserveAspectRatio='xMidYMid meet' viewBox='0 0 24 24'><g fill='none' stroke='currentColor' stroke-linecap='round' stroke-linejoin='round' stroke-width='2'><path d='M12 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7'></path><path d='M18.375 2.625a1 1 0 0 1 3 3l-9.013 9.014a2 2 0 0 1-.853.505l-2.873.84a.5.5 0 0 1-.62-.62l.84-2.873a2 2 0 0 1 .506-.852z'></path></g></svg>",
                              size: 20,
                              color: ColorResources.buttoncolor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Pinput(
                        length: length,
                        controller: controller,
                        focusNode: focusNode,
                        // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                        defaultPinTheme: defaultPinTheme,
                        submittedPinTheme: defaultPinTheme,

                        onCompleted: (pin) {
                          otp = pin;
                        },

                        focusedPinTheme: defaultPinTheme.copyWith(
                          height: 50,
                          width: 50,
                          decoration: defaultPinTheme.decoration!.copyWith(
                            border: Border.all(color: borderColor),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyWith(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: errorColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: OtpTimer(
                          ontap: (isWhatsapp) {
                            BlocProvider.of<AuthCubit>(context).resendOtp(number: widget.userNumber, isWhatsapp: isWhatsapp);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        decoration: BoxDecoration(color: ColorResources.buttoncolor, borderRadius: BorderRadius.circular(14)),
                        child: TextButton(
                          onPressed: _verifyButton,
                          child: Text(
                            'Verify OTP'.toUpperCase(),
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _verifyButton() {
    BlocProvider.of<AuthCubit>(context).verifyOtp(otp);
    // BlocProvider.of<AuthCubit>(context).verifyOtp(otp);
  }
}
