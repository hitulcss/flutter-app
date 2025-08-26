import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:sd_campus_app/features/cubit/auth/auth_cubit.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/auth/create_password_screen.dart';
// import 'package:sd_campus_app/view/screens/auth/otptimer.dart';

class ResetPasswordVerifyOtp extends StatefulWidget {
  const ResetPasswordVerifyOtp({super.key, required this.emailphoneNumber});
  final String emailphoneNumber;

  @override
  State<ResetPasswordVerifyOtp> createState() => _ResetPasswordVerifyOtpState();
}

class _ResetPasswordVerifyOtpState extends State<ResetPasswordVerifyOtp> {
  String otp = '';

  static const borderColor = Color.fromRGBO(114, 178, 238, 1);
  static const errorColor = Color.fromRGBO(255, 234, 238, 1);
  static const fillColor = Color.fromRGBO(222, 231, 240, .57);

  final controller = TextEditingController();
  final focusNode = FocusNode();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: GoogleFonts.notoSansDevanagari(
      fontSize: 22,
      color: const Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      color: fillColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.transparent),
    ),
  );

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthCubit>(context).resetPasswordVerifyOtp(
      widget.emailphoneNumber,
      '1234', //controller.text,
    );
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            // print(state);
            if (state is UpdatePasswordLoading) {
              Preferences.onLoading(context);
            }
            if (state is UpdatePasswordError || state is UpdatePasswordOtpResend) {
              Preferences.hideDialog(context);
            }
            if (state is UpdatePasswordOtpVerifySuccess) {
              Preferences.hideDialog(context);
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CreatePasswordScreen(
                      emailphoneNumber: widget.emailphoneNumber,
                    ),
                  ),
                );
              });
            }
          },
          builder: (context, state) {
            if (state is UpdatePasswordOtpVerifySuccess) {
              return Center(
                child: Icon(
                  Icons.verified,
                  size: 200,
                  color: ColorResources.buttoncolor,
                ),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageUrl: SvgImages.otpscreen,
                  height: 250,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Enter OTP',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sent on ',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      widget.emailphoneNumber,
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorResources.buttoncolor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        ' Change ',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 14,
                          color: ColorResources.buttoncolor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Pinput(
                  length: 4,
                  controller: controller,
                  focusNode: focusNode,
                  defaultPinTheme: defaultPinTheme,
                  onCompleted: (pin) {
                    otp = pin;
                  },
                  focusedPinTheme: defaultPinTheme.copyWith(
                    height: 68,
                    width: 64,
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: borderColor),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyWith(
                    decoration: BoxDecoration(
                      color: errorColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 50,
                  ),
                  decoration: BoxDecoration(
                    color: ColorResources.buttoncolor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextButton(
                    onPressed: () {
                      BlocProvider.of<AuthCubit>(context).resetPasswordVerifyOtp(
                        widget.emailphoneNumber,
                        '1234', //controller.text,
                      );
                    },
                    child: Text(
                      'Verify',
                      style: GoogleFonts.notoSansDevanagari(
                        color: ColorResources.textWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Did not recieve the code?'),
                    // OtpTimer(
                    // ontap: () {
                    // BlocProvider.of<AuthCubit>(context).resendPasswordOtp(
                    //   widget.emailphoneNumber,
                    // );
                    // },
                    // )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
