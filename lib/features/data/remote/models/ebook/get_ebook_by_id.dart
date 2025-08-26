import 'package:sd_campus_app/features/data/remote/models/ebook/get_all_ebook.dart';
import 'package:sd_campus_app/features/data/remote/models/get_product_by_id.dart';

class GetEbooksById {
  bool? status;
  GetEbooksByIdData? data;
  String? msg;

  GetEbooksById({
    this.status,
    this.data,
    this.msg,
  });

  GetEbooksById.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? GetEbooksByIdData.fromJson(json['data']) : null;
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

class GetEbooksByIdData {
  String? id;
  String? title;
  String? description;
  Category? category;
  List<Category>? categories;
  String? slug;
  String? metaTitle;
  String? metaDesc;
  List<String?>? keyFeature;
  String? featuredImage;
  ShareLink? shareLink;
  String? preview;
  List<String>? tags;
  List<SamplePdfs>? samplePdfs;
  String? regularPrice;
  String? salePrice;
  String? language;
  List<Reviews>? reviews;
  int? totalReviews;
  String? averageRating;
  RatingCounts? ratingCounts;
  int? totalRatings;

  GetEbooksByIdData({
    this.id,
    this.title,
    this.description,
    this.category,
    this.categories,
    this.slug,
    this.metaTitle,
    this.metaDesc,
    this.keyFeature,
    this.featuredImage,
    this.shareLink,
    this.preview,
    this.tags,
    this.samplePdfs,
    this.regularPrice,
    this.salePrice,
    this.language,
    this.reviews,
    this.totalReviews,
    this.averageRating,
    this.ratingCounts,
    this.totalRatings,
  });

  GetEbooksByIdData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    if (json['categories'] != null) {
      categories = <Category>[];
      json['categories'].forEach((v) {
        categories!.add(Category.fromJson(v));
      });
    }
    slug = json['slug'];
    metaTitle = json['metaTitle'];
    metaDesc = json['metaDesc'];
    keyFeature = json['keyFeature'].cast<String>();
    featuredImage = json['featuredImage'];
    shareLink = json['shareLink'] != null ? ShareLink.fromJson(json['shareLink']) : null;
    preview = json['preview'];
    tags = json['tags'].cast<String>();
    if (json['samplePdfs'] != null) {
      samplePdfs = <SamplePdfs>[];
      json['samplePdfs'].forEach((v) {
        samplePdfs!.add(SamplePdfs.fromJson(v));
      });
    }
    regularPrice = json['regularPrice'];
    salePrice = json['salePrice'];
    language = json['language'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    totalReviews = json['totalReviews'].runtimeType == int ? json['totalReviews'] : int.parse(json['totalReviews']);
    averageRating = json['averageRating'];
    ratingCounts = json['ratingCounts'] != null ? RatingCounts.fromJson(json['ratingCounts']) : null;
    totalRatings = json['totalRatings'].runtimeType == int ? json['totalRatings'] : int.parse(json['totalRatings']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    data['slug'] = slug;
    data['metaTitle'] = metaTitle;
    data['metaDesc'] = metaDesc;
    data['keyFeature'] = keyFeature;
    data['featuredImage'] = featuredImage;
    if (shareLink != null) {
      data['shareLink'] = shareLink!.toJson();
    }
    data['preview'] = preview;
    data['tags'] = tags;
    if (samplePdfs != null) {
      data['samplePdfs'] = samplePdfs!.map((v) => v.toJson()).toList();
    }
    data['regularPrice'] = regularPrice;
    data['salePrice'] = salePrice;
    data['language'] = language;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    data['totalReviews'] = totalReviews;
    data['averageRating'] = averageRating;
    if (ratingCounts != null) {
      data['ratingCounts'] = ratingCounts!.toJson();
    }
    data['totalRatings'] = totalRatings;
    return data;
  }
}

class SamplePdfs {
  String? fileLoc;
  String? name;
  String? size;

  SamplePdfs({this.fileLoc, this.name, this.size});

  SamplePdfs.fromJson(Map<String, dynamic> json) {
    fileLoc = json['fileLoc'];
    name = json['name'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileLoc'] = fileLoc;
    data['name'] = name;
    data['size'] = size;
    return data;
  }
}
