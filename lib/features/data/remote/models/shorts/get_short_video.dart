import 'dart:convert';

class GetShortVideos {
    bool? status;
    GetShortVideosData? data;
    String? msg;

    GetShortVideos({
        this.status,
        this.data,
        this.msg,
    });

    GetShortVideos copyWith({
        bool? status,
        GetShortVideosData? data,
        String? msg,
    }) => 
        GetShortVideos(
            status: status ?? this.status,
            data: data ?? this.data,
            msg: msg ?? this.msg,
        );

    factory GetShortVideos.fromJson(String str) => GetShortVideos.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetShortVideos.fromMap(Map<String, dynamic> json) => GetShortVideos(
        status: json["status"],
        data: json["data"] == null ? null : GetShortVideosData.fromMap(json["data"]),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
        "msg": msg,
    };
}

class GetShortVideosData {
    int? totalCounts;
    List<Short>? shorts;

    GetShortVideosData({
        this.totalCounts,
        this.shorts,
    });

    GetShortVideosData copyWith({
        int? totalCounts,
        List<Short>? shorts,
    }) => 
        GetShortVideosData(
            totalCounts: totalCounts ?? this.totalCounts,
            shorts: shorts ?? this.shorts,
        );

    factory GetShortVideosData.fromJson(String str) => GetShortVideosData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetShortVideosData.fromMap(Map<String, dynamic> json) => GetShortVideosData(
        totalCounts: json["totalCounts"],
        shorts: json["shorts"] == null ? [] : List<Short>.from(json["shorts"]!.map((x) => Short.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "totalCounts": totalCounts,
        "shorts": shorts == null ? [] : List<dynamic>.from(shorts!.map((x) => x.toMap())),
    };
}

class Short {
    String? title;
    Channel? channel;
    List<Url>? urls;
    String? description;
    ShareLink? shareLink;
    String? createdAt;
    int? shareCount;
    String? id;
    int? commentCounts;
    int? likes;
    int? views;
    bool? isLiked;
    bool? isSaved;

    Short({
        this.title,
        this.channel,
        this.urls,
        this.description,
        this.shareLink,
        this.createdAt,
        this.shareCount,
        this.id,
        this.commentCounts,
        this.likes,
        this.views,
        this.isLiked,
        this.isSaved,
    });

    Short copyWith({
        String? title,
        Channel? channel,
        List<Url>? urls,
        String? description,
        ShareLink? shareLink,
        String? createdAt,
        int? shareCount,
        String? id,
        int? commentCounts,
        int? likes,
        int? views,
        bool? isLiked,
        bool? isSaved,
    }) => 
        Short(
            title: title ?? this.title,
            channel: channel ?? this.channel,
            urls: urls ?? this.urls,
            description: description ?? this.description,
            shareLink: shareLink ?? this.shareLink,
            createdAt: createdAt ?? this.createdAt,
            shareCount: shareCount ?? this.shareCount,
            id: id ?? this.id,
            commentCounts: commentCounts ?? this.commentCounts,
            likes: likes ?? this.likes,
            views: views ?? this.views,
            isLiked: isLiked ?? this.isLiked,
            isSaved: isSaved ?? this.isSaved,
        );

    factory Short.fromJson(String str) => Short.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Short.fromMap(Map<String, dynamic> json) => Short(
        title: json["title"],
        channel: json["channel"] == null ? null : Channel.fromMap(json["channel"]),
        urls: json["urls"] == null ? [] : List<Url>.from(json["urls"]!.map((x) => Url.fromMap(x))),
        description: json["description"],
        shareLink: json["shareLink"] == null ? null : ShareLink.fromMap(json["shareLink"]),
        createdAt: json["createdAt"],
        shareCount: json["shareCount"],
        id: json["id"],
        commentCounts: json["commentCounts"],
        likes: json["likes"],
        views: json["views"],
        isLiked: json["isLiked"],
        isSaved: json["isSaved"],
    );

    Map<String, dynamic> toMap() => {
        "title": title,
        "channel": channel?.toMap(),
        "urls": urls == null ? [] : List<dynamic>.from(urls!.map((x) => x.toMap())),
        "description": description,
        "shareLink": shareLink?.toMap(),
        "createdAt": createdAt,
        "shareCount": shareCount,
        "id": id,
        "commentCounts": commentCounts,
        "likes": likes,
        "views": views,
        "isLiked": isLiked,
        "isSaved": isSaved,
    };
}

class Channel {
    String? id;
    String? name;
    String? profile;

    Channel({
        this.id,
        this.name,
        this.profile,
    });

    Channel copyWith({
        String? id,
        String? name,
        String? profile,
    }) => 
        Channel(
            id: id ?? this.id,
            name: name ?? this.name,
            profile: profile ?? this.profile,
        );

    factory Channel.fromJson(String str) => Channel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Channel.fromMap(Map<String, dynamic> json) => Channel(
        id: json["id"],
        name: json["name"],
        profile: json["profile"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "profile": profile,
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

class Url {
    String? label;
    String? url;

    Url({
        this.label,
        this.url,
    });

    Url copyWith({
        String? label,
        String? url,
    }) => 
        Url(
            label: label ?? this.label,
            url: url ?? this.url,
        );

    factory Url.fromJson(String str) => Url.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Url.fromMap(Map<String, dynamic> json) => Url(
        label: json["label"],
        url: json["url"],
    );

    Map<String, dynamic> toMap() => {
        "label": label,
        "url": url,
    };
}
