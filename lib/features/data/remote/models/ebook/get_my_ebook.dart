import 'package:sd_campus_app/features/data/remote/models/ebook/get_all_ebook.dart';

class GetMyEbooks {
  bool? status;
  List<GetMyEbooksData>? data;
  String? msg;

  GetMyEbooks({this.status, this.data, this.msg});

  GetMyEbooks.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetMyEbooksData>[];
      json['data'].forEach((v) {
        data!.add(GetMyEbooksData.fromJson(v));
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

class GetMyEbooksData {
  String? myEbookId;
  String? ebookId;
  String? ebookSlug;
  String? title;
  List<String>? keyFeatures;
  String? banner;
  int? chapterCount;
  String? language;
  ShareLink? shareLink;

  GetMyEbooksData({
    this.myEbookId,
    this.ebookId,
    this.ebookSlug,
    this.title,
    this.keyFeatures,
    this.banner,
    this.chapterCount,
    this.language,
    this.shareLink,
  });

  GetMyEbooksData.fromJson(Map<String, dynamic> json) {
    myEbookId = json['myEbookId'];
    ebookId = json['ebookId'];
    ebookSlug = json['ebookSlug'];
    title = json['title'];
    keyFeatures = json['keyFeatures'].cast<String>();
    banner = json['banner'];
    chapterCount = json['chapterCount'].runtimeType == String ? int.parse(json['chapterCount']) : json['chapterCount'];
    language = json['language'];
    shareLink = json['shareLink'] != null ? ShareLink.fromJson(json['shareLink']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['myEbookId'] = myEbookId;
    data['ebookId'] = ebookId;
    data['ebookSlug'] = ebookSlug;
    data['title'] = title;
    data['keyFeatures'] = keyFeatures;
    data['banner'] = banner;
    data['chapterCount'] = chapterCount;
    data['language'] = language;
    if (shareLink != null) {
      data['shareLink'] = shareLink!.toJson();
    }
    return data;
  }
}

