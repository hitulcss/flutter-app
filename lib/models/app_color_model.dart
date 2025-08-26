import 'dart:convert';

class AppColorModel {
  String buttonColor;
  String secPrimary;
  String textWhite;
  String textblack;
  String gray;
  String borderColor;
  String resourcesCardColor;
  String youtube;
  String telegarm;
  String greenshad;
  String edit;
  String delete;

  AppColorModel({
    this.buttonColor = "BF9603F2",
    this.secPrimary = "FFF2ECFF",
    this.textWhite = "FFFFFFFF",
    this.textblack = "FF333333",
    this.gray = "FF808080",
    this.borderColor = "FFD9D9D9",
    this.resourcesCardColor = "FF9603F2",
    this.youtube = "FFFFE6E6",
    this.telegarm = "FF000000",
    this.greenshad = "FF718744",
    this.edit = "FF30A2E2",
    this.delete = "FFFA7676",
  });

  AppColorModel copyWith({
    String? buttonColor,
    String? secPrimary,
    String? textWhite,
    String? textblack,
    String? gray,
    String? borderColor,
    String? resourcesCardColor,
    String? youtube,
    String? telegarm,
    String? greenshad,
    String? edit,
    String? delete,
  }) =>
      AppColorModel(
        buttonColor: buttonColor ?? this.buttonColor,
        secPrimary: secPrimary ?? this.secPrimary,
        textWhite: textWhite ?? this.textWhite,
        textblack: textblack ?? this.textblack,
        gray: gray ?? this.gray,
        borderColor: borderColor ?? this.borderColor,
        resourcesCardColor: resourcesCardColor ?? this.resourcesCardColor,
        youtube: youtube ?? this.youtube,
        telegarm: telegarm ?? this.telegarm,
        greenshad: greenshad ?? this.greenshad,
        edit: edit ?? this.edit,
        delete: delete ?? this.delete,
      );

  factory AppColorModel.fromJson(String str) => AppColorModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppColorModel.fromMap(Map<String, dynamic> json) => AppColorModel(
        buttonColor: json["button_color"],
        secPrimary: json["secPrimary"],
        textWhite: json["textWhite"],
        textblack: json["textblack"],
        gray: json["gray"],
        borderColor: json["borderColor"],
        resourcesCardColor: json["resourcesCardColor"],
        youtube: json["youtube"],
        telegarm: json["telegarm"],
        greenshad: json["greenshad"],
        edit: json["edit"],
        delete: json["delete"],
      );

  Map<String, dynamic> toMap() => {
        "button_color": buttonColor,
        "secPrimary": secPrimary,
        "textWhite": textWhite,
        "textblack": textblack,
        "gray": gray,
        "borderColor": borderColor,
        "resourcesCardColor": resourcesCardColor,
        "youtube": youtube,
        "telegarm": telegarm,
        "greenshad": greenshad,
        "edit": edit,
        "delete": delete,
      };
}
