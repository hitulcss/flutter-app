import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/util/color_resources.dart';

class AppTheme {
  final bool isDark;

  AppTheme({
    this.isDark = false,
  });
  ThemeData getThemeData() {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF2EBFF),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        color: ColorResources.textWhite,
        surfaceTintColor: ColorResources.textWhite,
        // backgroundColor: ColorResources.textWhite,
        // surfaceTintColor: colorModel(),
      ),
      // colorScheme: ,
      // primarySwatch: Colors.purple,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorResources.buttoncolor,
      ),
      textTheme: GoogleFonts.notoSansDevanagariTextTheme(),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorResources.buttoncolor,
          // : ColorResources.buttoncolor,
          disabledBackgroundColor: Colors.grey[300],
          shadowColor: Colors.grey[300],
          // elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        surfaceTintColor: Colors.white,
      ),
    );
  }
}
