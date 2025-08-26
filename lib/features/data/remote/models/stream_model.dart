class StreamModel {
  bool? status;
  List<StreamDataModel>? data;
  String? msg;

  StreamModel({this.status, this.data, this.msg});

  StreamModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data1'] != null) {
      data = <StreamDataModel>[];
      json['data1'].forEach((v) {
        data!.add(StreamDataModel.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> datatojson = <String, dynamic>{};
    datatojson['status'] = status;
    if (data != null) {
      datatojson['data1'] = data!.map((v) => v.toJson()).toList();
    }
    datatojson['msg'] = msg;
    return datatojson;
  }
}

class StreamDataModel {
  String? sId;
  String? title;
  String? icon;
  bool? isActive;
  String? createdAt;
  String? type;
  String? user;
  int? iV;
  String? slug;
  String? metaDesc;
  String? metaTitle;
  String? seoMetaDesc;
  String? seoMetaTitle;
  String? seoSlug;
  List<String>? tags;
  String? updatedAt;
  List<String>? faqs;
  List<SubCategories>? subCategories;

  StreamDataModel(
      {this.sId,
      this.title,
      this.icon,
      this.isActive,
      this.createdAt,
      this.type,
      this.user,
      this.iV,
      this.slug,
      this.metaDesc,
      this.metaTitle,
      this.seoMetaDesc,
      this.seoMetaTitle,
      this.seoSlug,
      this.tags,
      this.updatedAt,
      this.faqs,
      this.subCategories});

  StreamDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    icon = json['icon'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    type = json['type'];
    user = json['user'];
    iV = json['__v'];
    slug = json['slug'];
    metaDesc = json['metaDesc'];
    metaTitle = json['metaTitle'];
    seoMetaDesc = json['seoMetaDesc'];
    seoMetaTitle = json['seoMetaTitle'];
    seoSlug = json['seoSlug'];
    tags = json['tags'].cast<String>();
    updatedAt = json['updatedAt'];
    faqs = json['faqs'].cast<String>();
    if (json['subCategories'] != null) {
      subCategories = <SubCategories>[];
      json['subCategories'].forEach((v) {
        subCategories!.add(SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['icon'] = icon;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['type'] = type;
    data['user'] = user;
    data['__v'] = iV;
    data['slug'] = slug;
    data['metaDesc'] = metaDesc;
    data['metaTitle'] = metaTitle;
    data['seoMetaDesc'] = seoMetaDesc;
    data['seoMetaTitle'] = seoMetaTitle;
    data['seoSlug'] = seoSlug;
    data['tags'] = tags;
    data['updatedAt'] = updatedAt;
    data['faqs'] = faqs;
    if (subCategories != null) {
      data['subCategories'] =
          subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategories {
  String? id;
  String? title;
  String? slug;

  SubCategories({this.id, this.title, this.slug});

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    return data;
  }
}
