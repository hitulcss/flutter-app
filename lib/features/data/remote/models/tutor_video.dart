import 'dart:convert';

import 'package:sd_campus_app/util/enum/playertype.dart';

class TutorVideo {
  PlayerType enumtype;
  String? url;
  bool? isEnabled;
  bool? autoplay;
  bool? isLoop;
  String? link;

  TutorVideo({
    required this.enumtype,
    this.url,
    this.isEnabled,
    this.autoplay,
    this.isLoop,
    this.link,
  });

  TutorVideo copyWith({
    required PlayerType enumtype,
    String? url,
    bool? isEnabled,
    bool? autoplay,
    bool? isLoop,
    String? link,
  }) =>
      TutorVideo(
        enumtype: enumtype,
        url: url ?? this.url,
        isEnabled: isEnabled ?? this.isEnabled,
        autoplay: autoplay ?? this.autoplay,
        isLoop: isLoop ?? this.isLoop,
        link: link ?? this.link,
      );

  factory TutorVideo.fromJson(String str) => TutorVideo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TutorVideo.fromMap(Map<String, dynamic> json) => TutorVideo(
        enumtype: PlayerType.fromJson(json["enumtype"]),
        url: json["url"],
        isEnabled: json["isEnabled"],
        autoplay: json["autoplay"],
        isLoop: json["isLoop"],
        link: json["link"],
      );

  Map<String, dynamic> toMap() => {
        "enumtype": enumtype.name,
        "url": url,
        "isEnabled": isEnabled,
        "autoplay": autoplay,
        "isLoop": isLoop,
        "link": link,
      };
}
