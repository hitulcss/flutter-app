import 'package:sd_campus_app/features/data/remote/models/ebook/get_all_ebook.dart';

class GetStoreCategory {
  bool? status;
  List<GetStoreCategoryData>? data;
  String? msg;

  GetStoreCategory({this.status, this.data, this.msg});

  GetStoreCategory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetStoreCategoryData>[];
      json['data'].forEach((v) {
        data!.add(GetStoreCategoryData.fromJson(v));
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

class GetStoreCategoryData {
  String? id;
  String? title;
  String? icon;
  ShareLink? shareLink;
  List<ChildCat>? childCat;

  GetStoreCategoryData({this.id, this.title, this.icon, this.shareLink, this.childCat});

  GetStoreCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    icon = json['icon'];
    shareLink = json['shareLink'] != null
        ? ShareLink.fromJson(json['shareLink'])
        : null;
    if (json['childCat'] != null) {
      childCat = <ChildCat>[];
      json['childCat'].forEach((v) {
        childCat!.add(ChildCat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['icon'] = icon;
    if (shareLink != null) {
      data['shareLink'] = shareLink!.toJson();
    }
    if (childCat != null) {
      data['childCat'] = childCat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChildCat {
  String? id;
  String? title;
  String? icon;

  ChildCat({this.id, this.title, this.icon});

  ChildCat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['icon'] = icon;
    return data;
  }
}
