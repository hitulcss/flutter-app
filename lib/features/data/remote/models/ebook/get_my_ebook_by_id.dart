import 'package:sd_campus_app/features/data/remote/models/ebook/get_all_ebook.dart';

class GetMyEbooksById {
  bool? status;
  GetMyEbooksByIdData? data;
  String? msg;

  GetMyEbooksById({this.status, this.data, this.msg});

  GetMyEbooksById.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? GetMyEbooksByIdData.fromJson(json['data']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = msg;
    return data;
  }
}

class GetMyEbooksByIdData {
  String? title;
  String? banner;
  ShareLink? shareLink;
  String? description;
  String? language;
  List<String>? keyFeatures;
  List<String>? tags;
  int? chapterCount;
  List<ChapterWithTopics>? chapterWithTopics;

  GetMyEbooksByIdData({
    this.title,
    this.banner,
    this.shareLink,
    this.description,
    this.language,
    this.keyFeatures,
    this.tags,
    this.chapterCount,
    this.chapterWithTopics,
  });

  GetMyEbooksByIdData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    banner = json['banner'];
    shareLink = json['shareLink'] != null ? ShareLink.fromJson(json['shareLink']) : null;
    description = json['description'];
    language = json['language'];
    keyFeatures = json['keyFeatures'].cast<String>();
    tags = json['tags'].cast<String>();
    chapterCount = json['chapterCount'].runtimeType == String ? int.parse(json['chapterCount']) : json['chapterCount'];
    if (json['chapterWithTopics'] != null) {
      chapterWithTopics = <ChapterWithTopics>[];
      json['chapterWithTopics'].forEach((v) {
        chapterWithTopics!.add(ChapterWithTopics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['banner'] = banner;
    if (shareLink != null) {
      data['shareLink'] = shareLink!.toJson();
    }
    data['description'] = description;
    data['language'] = language;
    data['keyFeatures'] = keyFeatures;
    data['tags'] = tags;
    data['chapterCount'] = chapterCount;
    if (chapterWithTopics != null) {
      data['chapterWithTopics'] = chapterWithTopics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChapterWithTopics {
  String? chapterId;
  String? chapterTitle;
  String? chapterDescription;
  List<Topics>? topics;

  ChapterWithTopics({this.chapterId, this.chapterTitle, this.chapterDescription, this.topics});

  ChapterWithTopics.fromJson(Map<String, dynamic> json) {
    chapterId = json['chapterId'];
    chapterTitle = json['chapterTitle'];
    chapterDescription = json['chapterDescription'];
    if (json['topics'] != null) {
      topics = <Topics>[];
      json['topics'].forEach((v) {
        topics!.add(Topics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chapterId'] = chapterId;
    data['chapterTitle'] = chapterTitle;
    data['chapterDescription'] = chapterDescription;
    if (topics != null) {
      data['topics'] = topics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Topics {
  String? topicId;
  String? topicTitle;
  Details? details;

  Topics({this.topicId, this.topicTitle, this.details});

  Topics.fromJson(Map<String, dynamic> json) {
    topicId = json['topicId'];
    topicTitle = json['topicTitle'];
    details = json['details'] != null ? Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['topicId'] = topicId;
    data['topicTitle'] = topicTitle;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    return data;
  }
}

class Details {
  String? size;
  String? name;

  Details({this.size, this.name});

  Details.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['size'] = size;
    data['name'] = name;
    return data;
  }
}
