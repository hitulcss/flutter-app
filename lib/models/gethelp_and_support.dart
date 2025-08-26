import 'dart:convert';

class GetNeedHelp {
    bool? status;
    GetNeedHelpData? data;
    String? msg;

    GetNeedHelp({
        this.status,
        this.data,
        this.msg,
    });

    GetNeedHelp copyWith({
        bool? status,
        GetNeedHelpData? data,
        String? msg,
    }) => 
        GetNeedHelp(
            status: status ?? this.status,
            data: data ?? this.data,
            msg: msg ?? this.msg,
        );

    factory GetNeedHelp.fromJson(String str) => GetNeedHelp.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetNeedHelp.fromMap(Map<String, dynamic> json) => GetNeedHelp(
        status: json["status"],
        data: json["data"] == null ? null : GetNeedHelpData.fromMap(json["data"]),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
        "msg": msg,
    };
}

class GetNeedHelpData {
    List<NeedHelp>? needHelp;
    List<Video>? videos;

    GetNeedHelpData({
        this.needHelp,
        this.videos,
    });

    GetNeedHelpData copyWith({
        List<NeedHelp>? needHelp,
        List<Video>? videos,
    }) => 
        GetNeedHelpData(
            needHelp: needHelp ?? this.needHelp,
            videos: videos ?? this.videos,
        );

    factory GetNeedHelpData.fromJson(String str) => GetNeedHelpData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetNeedHelpData.fromMap(Map<String, dynamic> json) => GetNeedHelpData(
        needHelp: json["needHelp"] == null ? [] : List<NeedHelp>.from(json["needHelp"]!.map((x) => NeedHelp.fromMap(x))),
        videos: json["videos"] == null ? [] : List<Video>.from(json["videos"]!.map((x) => Video.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "needHelp": needHelp == null ? [] : List<dynamic>.from(needHelp!.map((x) => x.toMap())),
        "videos": videos == null ? [] : List<dynamic>.from(videos!.map((x) => x.toMap())),
    };
}

class NeedHelp {
    String? key;
    String? color;
    String? icon;
    List<TopicName>? topicName;

    NeedHelp({
        this.key,
        this.color,
        this.icon,
        this.topicName,
    });

    NeedHelp copyWith({
        String? key,
        String? color,
        String? icon,
        List<TopicName>? topicName,
    }) => 
        NeedHelp(
            key: key ?? this.key,
            color: color ?? this.color,
            icon: icon ?? this.icon,
            topicName: topicName ?? this.topicName,
        );

    factory NeedHelp.fromJson(String str) => NeedHelp.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory NeedHelp.fromMap(Map<String, dynamic> json) => NeedHelp(
        key: json["key"],
        color: json["color"],
        icon: json["icon"],
        topicName: json["topicName"] == null ? [] : List<TopicName>.from(json["topicName"]!.map((x) => TopicName.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "key": key,
        "color": color,
        "icon": icon,
        "topicName": topicName == null ? [] : List<dynamic>.from(topicName!.map((x) => x.toMap())),
    };
}

class TopicName {
    String? q;
    String? a;

    TopicName({
        this.q,
        this.a,
    });

    TopicName copyWith({
        String? q,
        String? a,
    }) => 
        TopicName(
            q: q ?? this.q,
            a: a ?? this.a,
        );

    factory TopicName.fromJson(String str) => TopicName.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TopicName.fromMap(Map<String, dynamic> json) => TopicName(
        q: json["q"],
        a: json["a"],
    );

    Map<String, dynamic> toMap() => {
        "q": q,
        "a": a,
    };
}

class Video {
    String? url;
    String? type;
    String? banner;
    String? title;

    Video({
        this.url,
        this.type,
        this.banner,
        this.title,
    });

    Video copyWith({
        String? url,
        String? type,
        String? banner,
        String? title,
    }) => 
        Video(
            url: url ?? this.url,
            type: type ?? this.type,
            banner: banner ?? this.banner,
            title: title ?? this.title,
        );

    factory Video.fromJson(String str) => Video.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Video.fromMap(Map<String, dynamic> json) => Video(
        url: json["url"],
        type: json["type"],
        banner: json["banner"],
        title: json["title"],
    );

    Map<String, dynamic> toMap() => {
        "url": url,
        "type": type,
        "banner": banner,
        "title": title,
    };
}
