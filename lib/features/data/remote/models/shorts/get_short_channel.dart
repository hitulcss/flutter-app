import 'dart:convert';

class GetShortChannel {
  bool? status;
  GetShortChannelData? data;
  String? msg;

  GetShortChannel({
    this.status,
    this.data,
    this.msg,
  });

  GetShortChannel copyWith({
    bool? status,
    GetShortChannelData? data,
    String? msg,
  }) =>
      GetShortChannel(
        status: status ?? this.status,
        data: data ?? this.data,
        msg: msg ?? this.msg,
      );

  factory GetShortChannel.fromJson(String str) => GetShortChannel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetShortChannel.fromMap(Map<String, dynamic> json) => GetShortChannel(
        status: json["status"],
        data: json["data"] == null ? null : GetShortChannelData.fromMap(json["data"]),
        msg: json["msg"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
        "msg": msg,
      };
}

class GetShortChannelData {
  String? id;
  String? name;
  String? description;
  ShareLink? shareLink;
  String? profile;
  List<String>? category;
  int? likeCount;
  int? viewCount;
  int? subscriberCount;
  int? shortCount;
  bool? isSubscribe;

  GetShortChannelData({
    this.id,
    this.name,
    this.description,
    this.shareLink,
    this.profile,
    this.category,
    this.likeCount,
    this.viewCount,
    this.subscriberCount,
    this.shortCount,
    this.isSubscribe,
  });

  GetShortChannelData copyWith({
    String? id,
    String? name,
    String? description,
    ShareLink? shareLink,
    String? profile,
    List<String>? category,
    int? likeCount,
    int? viewCount,
    int? subscriberCount,
    int? shortCount,
    bool? isSubscribe,
  }) =>
      GetShortChannelData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        shareLink: shareLink ?? this.shareLink,
        profile: profile ?? this.profile,
        category: category ?? this.category,
        likeCount: likeCount ?? this.likeCount,
        viewCount: viewCount ?? this.viewCount,
        subscriberCount: subscriberCount ?? this.subscriberCount,
        shortCount: shortCount ?? this.shortCount,
        isSubscribe: isSubscribe ?? this.isSubscribe,
      );

  factory GetShortChannelData.fromJson(String str) => GetShortChannelData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetShortChannelData.fromMap(Map<String, dynamic> json) => GetShortChannelData(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        shareLink: json["shareLink"] == null ? null : ShareLink.fromMap(json["shareLink"]),
        profile: json["profile"],
        category: json["category"] == null ? [] : List<String>.from(json["category"]!.map((x) => x)),
        likeCount: json["likeCount"],
        viewCount: json["viewCount"],
        subscriberCount: json["subscriberCount"],
        shortCount: json["shortCount"],
        isSubscribe: json["isSubscribe"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "shareLink": shareLink?.toMap(),
        "profile": profile,
        "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
        "likeCount": likeCount,
        "viewCount": viewCount,
        "subscriberCount": subscriberCount,
        "shortCount": shortCount,
        "isSubscribe": isSubscribe,
      };
}

class ShareLink {
  String? link;
  String? text;

  ShareLink({
    this.link,
    this.text,
  });

  ShareLink copyWith({
    String? link,
    String? text,
  }) =>
      ShareLink(
        link: link ?? this.link,
        text: text ?? this.text,
      );

  factory ShareLink.fromJson(String str) => ShareLink.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ShareLink.fromMap(Map<String, dynamic> json) => ShareLink(
        link: json["link"],
        text: json["text"],
      );

  Map<String, dynamic> toMap() => {
        "link": link,
        "text": text,
      };
}
