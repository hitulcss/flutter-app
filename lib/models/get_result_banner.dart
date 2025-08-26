import 'dart:convert';

class GetResultBanner {
    bool? status;
    List<GetResultBannerData>? data;
    String? msg;

    GetResultBanner({
        this.status,
        this.data,
        this.msg,
    });

    GetResultBanner copyWith({
        bool? status,
        List<GetResultBannerData>? data,
        String? msg,
    }) => 
        GetResultBanner(
            status: status ?? this.status,
            data: data ?? this.data,
            msg: msg ?? this.msg,
        );

    factory GetResultBanner.fromJson(String str) => GetResultBanner.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetResultBanner.fromMap(Map<String, dynamic> json) => GetResultBanner(
        status: json["status"],
        data: json["data"] == null ? [] : List<GetResultBannerData>.from(json["data"]!.map((x) => GetResultBannerData.fromMap(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "msg": msg,
    };
}

class GetResultBannerData {
    String? title;
    String? banner;

    GetResultBannerData({
        this.title,
        this.banner,
    });

    GetResultBannerData copyWith({
        String? title,
        String? banner,
    }) => 
        GetResultBannerData(
            title: title ?? this.title,
            banner: banner ?? this.banner,
        );

    factory GetResultBannerData.fromJson(String str) => GetResultBannerData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetResultBannerData.fromMap(Map<String, dynamic> json) => GetResultBannerData(
        title: json["title"],
        banner: json["banner"],
    );

    Map<String, dynamic> toMap() => {
        "title": title,
        "banner": banner,
    };
}
