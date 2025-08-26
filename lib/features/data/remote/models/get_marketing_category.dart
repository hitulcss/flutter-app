class GetMarketingCategory {
  bool? status;
  List<GetMarketingCategoryData>? data;
  String? msg;

  GetMarketingCategory({this.status, this.data, this.msg});

  GetMarketingCategory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetMarketingCategoryData>[];
      json['data'].forEach((v) {
        data!.add(GetMarketingCategoryData.fromJson(v));
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

class GetMarketingCategoryData {
  String? id;
  String? title;
  Category? category;
  String? slug;
  String? featuredImage;
  List<String>? images;
  String? code;
  String? regularPrice;
  bool? isSaleLive;
  String? marketingCat;
  String? maxPurchaseQty;
  bool? isWishList;
  String? language;
  String? salePrice;
  String? badge;
  String? averageRating;

  GetMarketingCategoryData(
      {this.id,
      this.title,
      this.category,
      this.slug,
      this.featuredImage,
      this.images,
      this.code,
      this.regularPrice,
      this.isSaleLive,
      this.marketingCat,
      this.maxPurchaseQty,
      this.isWishList,
      this.language,
      this.salePrice,
      this.badge,
      this.averageRating});

  GetMarketingCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    slug = json['slug'];
    featuredImage = json['featuredImage'];
    images = json['images'].cast<String>();
    code = json['code'];
    regularPrice = json['regularPrice'];
    isSaleLive = json['isSaleLive'];
    marketingCat = json['marketingCat'];
    maxPurchaseQty = json['maxPurchaseQty'];
    isWishList = json['isWishList'];
    language = json['language'];
    salePrice = json['salePrice'];
    badge = json['badge'];
    averageRating = json['averageRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['slug'] = slug;
    data['featuredImage'] = featuredImage;
    data['images'] = images;
    data['code'] = code;
    data['regularPrice'] = regularPrice;
    data['isSaleLive'] = isSaleLive;
    data['marketingCat'] = marketingCat;
    data['maxPurchaseQty'] = maxPurchaseQty;
    data['isWishList'] = isWishList;
    data['language'] = language;
    data['salePrice'] = salePrice;
    data['badge'] = badge;
    data['averageRating'] = averageRating;
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
