import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/models/app_color_model.dart';

class ColorResources {
  static AppColorModel remotecolor = AppColorModel.fromMap(json.decode(
    remoteConfig.getValue("app_color").asString(),
  ));
  static Color buttoncolor = Color(
    int.parse(
      remotecolor.buttonColor,
      radix: 16,
    ),
  ); // 0xBF9603F2);
  static Color secPrimary = Color(
    int.parse(
      remotecolor.secPrimary,
      radix: 16,
    ),
  );
  static Color textWhite = Color(
    int.parse(
      remotecolor.textWhite,
      radix: 16,
    ),
  ); //0xFFFFFFFF);
  static Color textBlackSec = Color(
    int.parse(
      remotecolor.textblack,
      radix: 16,
    ),
  ).withValues(alpha: 0.75);
  static Color textblack = Color(
    int.parse(
      remotecolor.textblack,
      radix: 16,
    ),
  ); //0xFF333333);
  static Color gray = Color(
    int.parse(
      remotecolor.gray,
      radix: 16,
    ),
  ); //0xFF808080);
  static Color borderColor = Color(
    int.parse(
      remotecolor.borderColor,
      radix: 16,
    ),
  ); //;

  static Color resourcesCardColor = Color(
    int.parse(
      remotecolor.resourcesCardColor,
      radix: 16,
    ),
  ); //0xFF9603F2);

  static Color youtube = Color(
    int.parse(
      remotecolor.youtube,
      radix: 16,
    ),
  ); //0xFFFFE6E6);
  static Color telegarm = Color(
    int.parse(
      remotecolor.telegarm,
      radix: 16,
    ),
  ); //0xFFC0DEFF);

  static Color greenshad = Color(
    int.parse(
      remotecolor.greenshad,
      radix: 16,
    ),
  ); //0xFF718744);
  static Color edit = Color(
    int.parse(
      remotecolor.edit,
      radix: 16,
    ),
  ); //0xFF30A2E2);
  static Color delete = Color(
    int.parse(
      remotecolor.delete,
      radix: 16,
    ),
  ); //0xFFFA7676);
}
