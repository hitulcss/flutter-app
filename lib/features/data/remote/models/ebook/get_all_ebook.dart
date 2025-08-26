class GetAllEbooks {
  bool? status;
  GetAllEbooksData? data;
  String? msg;

  GetAllEbooks({this.status, this.data, this.msg});

  GetAllEbooks.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? GetAllEbooksData.fromJson(json['data']) : null;
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

class GetAllEbooksData {
  List<Category>? categories;
  List<Ebooks>? ebooks;
  int? totalCounts;

  GetAllEbooksData({this.categories, this.ebooks, this.totalCounts});

  GetAllEbooksData.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Category>[];
      json['categories'].forEach((v) {
        categories!.add(Category.fromJson(v));
      });
    }
    if (json['ebooks'] != null) {
      ebooks = <Ebooks>[];
      json['ebooks'].forEach((v) {
        ebooks!.add(Ebooks.fromJson(v));
      });
    }
    totalCounts = json['totalCounts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (ebooks != null) {
      data['ebooks'] = ebooks!.map((v) => v.toJson()).toList();
    }
    data['totalCounts'] = totalCounts;
    return data;
  }
}

class Category {
  String? id;
  String? title;
  String? slug;

  Category({this.id, this.title, this.slug});

  Category.fromJson(Map<String, dynamic> json) {
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

class Ebooks {
  String? id;
  String? title;
  int? chapterCount;
  List<String>? keyFeatures;
  Category? category;
  List<Category>? categories;
  String? parentCategory;
  String? slug;
  String? preview;
  String? banner;
  ShareLink? shareLink;
  String? regularPrice;
  String? language;
  String? salePrice;
  String? averageRating;
  int? reviewCount;

  Ebooks({this.id, this.title, this.chapterCount, this.keyFeatures, this.category, this.categories, this.parentCategory, this.slug, this.preview, this.banner, this.shareLink, this.regularPrice, this.language, this.salePrice, this.averageRating, this.reviewCount});

  Ebooks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    chapterCount = json['chapterCount'].runtimeType == String ? int.parse(json['chapterCount']) : json['chapterCount'];
    keyFeatures = json['keyFeatures'].cast<String>();
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    if (json['categories'] != null) {
      categories = <Category>[];
      json['categories'].forEach((v) {
        categories!.add(Category.fromJson(v));
      });
    }
    parentCategory = json['parentCategory'];
    slug = json['slug'];
    preview = json['preview'];
    banner = json['banner'];
    shareLink = json['shareLink'] != null ? ShareLink.fromJson(json['shareLink']) : null;
    regularPrice = json['regularPrice'];
    language = json['language'];
    salePrice = json['salePrice'];
    averageRating = json['averageRating'];
    reviewCount = json['reviewCount'].runtimeType == String ? int.parse(json['reviewCount']) : json['reviewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['chapterCount'] = chapterCount;
    data['keyFeatures'] = keyFeatures;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    data['parentCategory'] = parentCategory;
    data['slug'] = slug;
    data['preview'] = preview;
    data['banner'] = banner;
    if (shareLink != null) {
      data['shareLink'] = shareLink!.toJson();
    }
    data['regularPrice'] = regularPrice;
    data['language'] = language;
    data['salePrice'] = salePrice;
    data['averageRating'] = averageRating;
    data['reviewCount'] = reviewCount;
    return data;
  }
}

class ShareLink {
  String? link;
  String? text;

  ShareLink({this.link, this.text});

  ShareLink.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link'] = link;
    data['text'] = text;
    return data;
  }
}
