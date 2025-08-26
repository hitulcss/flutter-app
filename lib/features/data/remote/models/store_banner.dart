class GetStoreBanner {
  bool? status;
  List<GetStoreBannerData>? data;
  String? msg;

  GetStoreBanner({this.status, this.data, this.msg});

  GetStoreBanner.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetStoreBannerData>[];
      json['data'].forEach((v) {
        data!.add(GetStoreBannerData.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = msg;
    return data;
  }
}

class GetStoreBannerData {
  String? id;
  String? icon;
  String? bannerType;
  String? link;
  LinkWith? linkWith;

  GetStoreBannerData({this.id, this.icon, this.bannerType, this.link, this.linkWith});

  GetStoreBannerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    bannerType = json['bannerType'];
    link = json['link'];
    linkWith = json['linkWith'] != null
        ? LinkWith.fromJson(json['linkWith'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['icon'] = icon;
    data['bannerType'] = bannerType;
    data['link'] = link;
    if (linkWith != null) {
      data['linkWith'] = linkWith!.toJson();
    }
    return data;
  }
}

class LinkWith {
  String? id;
  String? title;

  LinkWith({this.id, this.title});

  LinkWith.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}
