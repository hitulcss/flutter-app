class GetWishlistItems {
  bool? status;
  List<GetWishlistItemsData>? data;
  String? msg;

  GetWishlistItems({this.status, this.data, this.msg});

  GetWishlistItems.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetWishlistItemsData>[];
      json['data'].forEach((v) {
        data!.add(GetWishlistItemsData.fromJson(v));
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

class GetWishlistItemsData {
  String? id;
  String? title;
  String? featuredImage;
  String? salePrice;
  String? regularPrice;

  GetWishlistItemsData(
      {this.id,
      this.title,
      this.featuredImage,
      this.salePrice,
      this.regularPrice});

  GetWishlistItemsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    featuredImage = json['featuredImage'];
    salePrice = json['salePrice'];
    regularPrice = json['regularPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['featuredImage'] = featuredImage;
    data['salePrice'] = salePrice;
    data['regularPrice'] = regularPrice;
    return data;
  }
}
