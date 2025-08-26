class GetCart {
  bool? status;
  List<GetCartData>? data;
  String? msg;

  GetCart({this.status, this.data, this.msg});

  GetCart.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetCartData>[];
      json['data'].forEach((v) {
        data!.add(GetCartData.fromJson(v));
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

class GetCartData {
  String? id;
  String? title;
  String? featuredImage;
  String? salePrice;
  String? regularPrice;
  String? quantity;
  String? maxPurchaseQty;

  GetCartData({
    this.id,
    this.title,
    this.featuredImage,
    this.salePrice,
    this.regularPrice,
    this.quantity,
    this.maxPurchaseQty,
  });

  GetCartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    featuredImage = json['featuredImage'];
    salePrice = json['salePrice'];
    regularPrice = json['regularPrice'];
    quantity = json['quantity'];
    maxPurchaseQty = json["maxPurchaseQty"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['featuredImage'] = featuredImage;
    data['salePrice'] = salePrice;
    data['regularPrice'] = regularPrice;
    data['quantity'] = quantity;
    data["maxPurchaseQty"] = maxPurchaseQty;
    return data;
  }
}
