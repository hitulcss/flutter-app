import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

class OtpTimer extends StatefulWidget {
  final void Function(bool isWhatsapp) ontap;
  const OtpTimer({super.key, required this.ontap});

  @override
  State<OtpTimer> createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  int secondsRemaining = 60;
  bool enableResend = false;
  Timer? timer;
  @override
  initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        safeSetState(() {
          secondsRemaining--;
        });
      } else {
        safeSetState(() {
          enableResend = true;
        });
      }
    });
  }

  void otpexptime() {
    int otphitcout = SharedPreferenceHelper.getInt(Preferences.otphitcount);

    if (otphitcout == 2) {
      if (DateTime.now().difference(DateFormat('dd-MM-yyyy HH:mm:ss').parse(SharedPreferenceHelper.getString(Preferences.otpexptime)!)).inMinutes <= 0) {
        safeSetState(() {
          SharedPreferenceHelper.setInt(Preferences.otphitcount, 0);
        });
      }
    }
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int otphitcout = SharedPreferenceHelper.getInt(Preferences.otphitcount);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Did not recieve the code?'),
              enableResend
                  ? InkWell(
                      onTap: () {
                        if (otphitcout < 3) {
                          safeSetState(() {
                            enableResend = false;
                            secondsRemaining = 60;
                            SharedPreferenceHelper.setInt(Preferences.otphitcount, otphitcout + 1);
                            SharedPreferenceHelper.setString(Preferences.otpexptime, DateTime.now().add(const Duration(hours: 12)).toString());
                          });
                          widget.ontap.call(false);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(content: Text(' You have reached max limit, try again after 12 hours'));
                            },
                          );
                        }
                      },
                      child: Text(
                        ' Resend OTP',
                        style: GoogleFonts.notoSansDevanagari(color: ColorResources.buttoncolor),
                      ),
                    )
                  : Text(
                      '  Resend in $secondsRemaining seconds',
                      style: TextStyle(
                        color: ColorResources.buttoncolor,
                      ),
                    ),
            ],
          ),
          SizedBox(height: 10),
          enableResend
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(children: [
                        Expanded(child: Divider()),
                        Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorResources.borderColor),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text("OR")),
                        Expanded(child: Divider())
                      ]),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        if (otphitcout < 3) {
                          safeSetState(() {
                            enableResend = false;
                            secondsRemaining = 60;
                            SharedPreferenceHelper.setInt(Preferences.otphitcount, otphitcout + 1);
                            SharedPreferenceHelper.setString(Preferences.otpexptime, DateTime.now().add(const Duration(hours: 12)).toString());
                          });
                          widget.ontap.call(true);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(content: Text(' You have reached max limit, try again after 12 hours'));
                            },
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          // border: Border.all(color: ColorResources.buttoncolor),
                          color: Color(0xFFE8E7E7).withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            Image.network(SvgImages.whatsappbackgroung, height: 20, width: 20),
                            Text(
                              'Get OTP On WhatsApp',
                              style: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.textblack,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
