class Getbannerdetails {
  bool? status;
  List<Data>? data;
  String? msg;

  Getbannerdetails({this.status, this.data, this.msg});

  Getbannerdetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  String? sId;
  String? title;
  String? createdAt;
  String? link;
  LinkWith? linkWith;
  bool? isActive;
  String? bannerUrl;

  Data({this.sId, this.title, this.createdAt, this.link, this.linkWith, this.isActive, this.bannerUrl});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    createdAt = json['created_at'];
    link = json['link'];
    linkWith = json['linkWith'] != null ? LinkWith.fromJson(json['linkWith']) : null;
    isActive = json['is_active'];
    bannerUrl = json['banner_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['created_at'] = createdAt;
    data['link'] = link;
    if (linkWith != null) {
      data['linkWith'] = linkWith!.toJson();
    }
    data['is_active'] = isActive;
    data['banner_url'] = bannerUrl;
    return data;
  }
}

class LinkWith {
  String? id;
  String? name;

  LinkWith({this.id, this.name});

  LinkWith.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
