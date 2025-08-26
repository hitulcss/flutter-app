import 'dart:convert';

class GetSuccessStories {
    bool? status;
    List<GetSuccessStoriesData>? data;
    String? msg;

    GetSuccessStories({
        this.status,
        this.data,
        this.msg,
    });

    GetSuccessStories copyWith({
        bool? status,
        List<GetSuccessStoriesData>? data,
        String? msg,
    }) => 
        GetSuccessStories(
            status: status ?? this.status,
            data: data ?? this.data,
            msg: msg ?? this.msg,
        );

    factory GetSuccessStories.fromJson(String str) => GetSuccessStories.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetSuccessStories.fromMap(Map<String, dynamic> json) => GetSuccessStories(
        status: json["status"],
        data: json["data"] == null ? [] : List<GetSuccessStoriesData>.from(json["data"]!.map((x) => GetSuccessStoriesData.fromMap(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "msg": msg,
    };
}

class GetSuccessStoriesData {
    String? desc;
    String? resultInfo;
    String? url;
    User? user;
    String? category;

    GetSuccessStoriesData({
        this.desc,
        this.resultInfo,
        this.url,
        this.user,
        this.category,
    });

    GetSuccessStoriesData copyWith({
        String? desc,
        String? resultInfo,
        String? url,
        User? user,
        String? category,
    }) => 
        GetSuccessStoriesData(
            desc: desc ?? this.desc,
            resultInfo: resultInfo ?? this.resultInfo,
            url: url ?? this.url,
            user: user ?? this.user,
            category: category ?? this.category,
        );

    factory GetSuccessStoriesData.fromJson(String str) => GetSuccessStoriesData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetSuccessStoriesData.fromMap(Map<String, dynamic> json) => GetSuccessStoriesData(
        desc: json["desc"],
        resultInfo: json["resultInfo"],
        url: json["url"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        category: json["category"],
    );

    Map<String, dynamic> toMap() => {
        "desc": desc,
        "resultInfo": resultInfo,
        "url": url,
        "user": user?.toMap(),
        "category": category,
    };
}

class User {
    String? name;
    String? profile;

    User({
        this.name,
        this.profile,
    });

    User copyWith({
        String? name,
        String? profile,
    }) => 
        User(
            name: name ?? this.name,
            profile: profile ?? this.profile,
        );

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        name: json["name"],
        profile: json["profile"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "profile": profile,
    };
}
