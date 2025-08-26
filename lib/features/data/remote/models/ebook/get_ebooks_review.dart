import 'package:sd_campus_app/features/data/remote/models/get_product_by_id.dart';

class GetEbooksReviews {
  bool? status;
  GetEbooksReviewsData? data;
  String? msg;

  GetEbooksReviews({this.status, this.data, this.msg});

  GetEbooksReviews.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? GetEbooksReviewsData.fromJson(json['data']) : null;
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

class GetEbooksReviewsData {
  List<Reviews>? reviews;
  int? totalCounts;

  GetEbooksReviewsData({this.reviews, this.totalCounts});

  GetEbooksReviewsData.fromJson(Map<String, dynamic> json) {
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    totalCounts = json['totalCounts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    data['totalCounts'] = totalCounts;
    return data;
  }
}
