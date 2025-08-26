class Getproductlist {
  bool? status;
  List<GetproductlistData>? data;
  String? msg;

  Getproductlist({this.status, this.data, this.msg});

  Getproductlist.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetproductlistData>[];
      json['data'].forEach((v) {
        data!.add(GetproductlistData.fromJson(v));
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

class GetproductlistData {
  String? id;
  String? title;
  String? slug;
  String? featuredImage;
  List<String>? images;
  String? code;
  String? regularPrice;
  bool? isSaleLive;
  String? language;
  String? salePrice;
  String? badge;
  bool? isWishList;
  String? averageRating;

  GetproductlistData({this.id, this.title, this.slug, this.featuredImage, this.images, this.code, this.regularPrice, this.isSaleLive, this.language, this.salePrice, this.badge, this.averageRating});

  GetproductlistData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    featuredImage = json['featuredImage'];
    images = json['images'].cast<String>();
    code = json['code'];
    regularPrice = json['regularPrice'];
    isSaleLive = json['isSaleLive'];
    language = json['language'];
    salePrice = json['salePrice'];
    isWishList = json['isWishList'];
    badge = json['badge'];
    averageRating = json['averageRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['featuredImage'] = featuredImage;
    data['images'] = images;
    data['code'] = code;
    data['regularPrice'] = regularPrice;
    data['isSaleLive'] = isSaleLive;
    data['language'] = language;
    data['isWishList'] = isWishList;
    data['salePrice'] = salePrice;
    data['badge'] = badge;
    data['averageRating'] = averageRating;
    return data;
  }
}
