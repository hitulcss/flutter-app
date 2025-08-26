import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';

class GetProductById {
  bool? status;
  GetProductByIdData? data;
  String? msg;

  GetProductById({this.status, this.data, this.msg});

  GetProductById.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? GetProductByIdData.fromJson(json['data']) : null;
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

class GetProductByIdData {
  String? id;
  String? title;
  String? slug;
  String? featuredImage;
  List<String>? images;
  ShareUrl? shareUrl;
  String? code;
  String? desc;
  List<String>? tags;
  String? regularPrice;
  bool? isSaleLive;
  String? salePrice;
  String? inStock;
  String? maxPurchaseQty;
  String? deliveryType;
  String? language;
  String? badge;
  List<Attributes>? attributes;
  List<Variations>? variations;
  bool? isCoinApplicable;
  String? maxAllowedCoins;
  List<Reviews>? reviews;
  int? totalReviews;
  String? averageRating;
  RatingCounts? ratingCounts;
  int? totalRatings;
  bool? isWishList;
  List<Offers>? offers;

  GetProductByIdData({
    this.shareUrl,
    this.id,
    this.title,
    this.slug,
    this.featuredImage,
    this.images,
    this.code,
    this.desc,
    this.tags,
    this.regularPrice,
    this.isSaleLive,
    this.salePrice,
    this.inStock,
    this.maxPurchaseQty,
    this.deliveryType,
    this.language,
    this.badge,
    this.attributes,
    this.variations,
    this.isCoinApplicable,
    this.maxAllowedCoins,
    this.reviews,
    this.totalReviews,
    this.averageRating,
    this.ratingCounts,
    this.totalRatings,
    this.isWishList,
    this.offers,
  });

  GetProductByIdData.fromJson(Map<String, dynamic> json) {
    shareUrl = json['shareLink'] != null ? ShareUrl.fromJson(json['shareLink']) : null;
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    featuredImage = json['featuredImage'];
    images = json['images'].cast<String>();
    code = json['code'];
    desc = json['desc'];
    tags = json['tags'].cast<String>();
    regularPrice = json['regularPrice'];
    isSaleLive = json['isSaleLive'];
    salePrice = json['salePrice'];
    isWishList = json["isWishList"];
    inStock = json['inStock'];
    maxPurchaseQty = json['maxPurchaseQty'];
    deliveryType = json['deliveryType'];
    language = json['language'];
    badge = json['badge'];
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(Attributes.fromJson(v));
      });
    }
    if (json['variations'] != null) {
      variations = <Variations>[];
      json['variations'].forEach((v) {
        variations!.add(Variations.fromJson(v));
      });
    }
    isCoinApplicable = json['isCoinApplicable'];
    maxAllowedCoins = json['maxAllowedCoins'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    totalReviews = json['totalReviews'];
    averageRating = json['averageRating'];
    ratingCounts = json['ratingCounts'] != null ? RatingCounts.fromJson(json['ratingCounts']) : null;
    totalRatings = json['totalRatings'];
    if (json['offers'] != null) {
      offers = <Offers>[];
      json['offers'].forEach((v) {
        offers!.add(Offers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["shareLink"] = shareUrl;
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['featuredImage'] = featuredImage;
    data['images'] = images;
    data['code'] = code;
    data['desc'] = desc;
    data['tags'] = tags;
    data['regularPrice'] = regularPrice;
    data['isSaleLive'] = isSaleLive;
    data['salePrice'] = salePrice;
    data['inStock'] = inStock;
    data['isWishList'] = isWishList;
    data['maxPurchaseQty'] = maxPurchaseQty;
    data['deliveryType'] = deliveryType;
    data['language'] = language;
    data['badge'] = badge;
    if (attributes != null) {
      data['attributes'] = attributes!.map((v) => v.toJson()).toList();
    }
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    data['isCoinApplicable'] = isCoinApplicable;
    data['maxAllowedCoins'] = maxAllowedCoins;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    data['totalReviews'] = totalReviews;
    data['averageRating'] = averageRating;
    if (ratingCounts != null) {
      data['ratingCounts'] = ratingCounts!.toJson();
    }
    data['totalRatings'] = totalRatings;
    if (offers != null) {
      data['offers'] = offers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Offers {
  String? sId;
  String? couponCode;
  String? couponType;
  int? couponValue;

  Offers({this.sId, this.couponCode, this.couponType, this.couponValue});

  Offers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    couponCode = json['couponCode'];
    couponType = json['couponType'];
    couponValue = json['couponValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['couponCode'] = couponCode;
    data['couponType'] = couponType;
    data['couponValue'] = couponValue;
    return data;
  }
}

class Attributes {
  String? color;

  Attributes({this.color});

  Attributes.fromJson(Map<String, dynamic> json) {
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color;
    return data;
  }
}

class Variations {
  String? color;
  String? code;
  String? regularPrice;
  String? salePrice;
  Schedule? schedule;
  String? desc;

  Variations({this.color, this.code, this.regularPrice, this.salePrice, this.schedule, this.desc});

  Variations.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    code = json['code'];
    regularPrice = json['regularPrice'];
    salePrice = json['salePrice'];
    schedule = json['schedule'] != null ? Schedule.fromJson(json['schedule']) : null;
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color;
    data['code'] = code;
    data['regularPrice'] = regularPrice;
    data['salePrice'] = salePrice;
    if (schedule != null) {
      data['schedule'] = schedule!.toJson();
    }
    data['desc'] = desc;
    return data;
  }
}

class Schedule {
  String? startDate;
  String? endDate;

  Schedule({this.startDate, this.endDate});

  Schedule.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }
}

class Reviews {
  String? sId;
  User? user;
  String? title;
  String? rating;
  String? description;

  Reviews({this.sId, this.user, this.title, this.rating, this.description});

  Reviews.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    title = json['title'];
    rating = json['rating'].runtimeType == int ? json['rating'].toString() : json['rating'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['title'] = title;
    data['rating'] = rating;
    data['description'] = description;
    return data;
  }
}

class User {
  String? name;
  String? profilePhoto;

  User({this.name, this.profilePhoto});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePhoto = json['profilePhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['profilePhoto'] = profilePhoto;
    return data;
  }
}

class RatingCounts {
  int? i1;
  int? i2;
  int? i3;
  int? i4;
  int? i5;

  RatingCounts({this.i1, this.i2, this.i3, this.i4, this.i5});

  RatingCounts.fromJson(Map<String, dynamic> json) {
    i1 = json['1'];
    i2 = json['2'];
    i3 = json['3'];
    i4 = json['4'];
    i5 = json['5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['1'] = i1;
    data['2'] = i2;
    data['3'] = i3;
    data['4'] = i4;
    data['5'] = i5;
    return data;
  }
}
