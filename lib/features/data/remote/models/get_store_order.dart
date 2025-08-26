class GetStoreOrders {
  bool? status;
  List<GetStoreOrdersData>? data;
  String? msg;

  GetStoreOrders({this.status, this.data, this.msg});

  GetStoreOrders.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetStoreOrdersData>[];
      json['data'].forEach((v) {
        data!.add(GetStoreOrdersData.fromJson(v));
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

class GetStoreOrdersData {
  String? id;
  String? storeOrderId;
  String? couponId;
  List<Products>? products;
  String? allAmount;
  String? productDiscount;
  String? totalAmount;
  String? orderId;
  String? orderType;
  String? deliveryCharges;
  bool? isPaid;
  ShippingAddress? shippingAddress;
  bool? isRated;
  String? rating;
  String? paymentStatus;
  String? deliveryStatus;
  String? invoice;
  String? couponDiscount;
  String? purchaseDate;
  String? deliveredDate;
  String? returnDate;
  String? dispatchDate;
  String? cancelDate;
  String? invoiceDate;
  String? platform;
  String? isReturn;
  String? awbNumber;
  String? trackingId;
  String? trackingLink;

  GetStoreOrdersData({
    this.id,
    this.storeOrderId,
    this.couponId,
    this.products,
    this.allAmount,
    this.productDiscount,
    this.totalAmount,
    this.orderId,
    this.orderType,
    this.deliveryCharges,
    this.isPaid,
    this.shippingAddress,
    this.isRated,
    this.rating,
    this.paymentStatus,
    this.deliveryStatus,
    this.invoice,
    this.couponDiscount,
    this.purchaseDate,
    this.deliveredDate,
    this.returnDate,
    this.dispatchDate,
    this.cancelDate,
    this.invoiceDate,
    this.platform,
    this.isReturn,
    this.awbNumber,
    this.trackingId,
    this.trackingLink,
  });

  GetStoreOrdersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeOrderId = json['storeOrderId'];
    couponId = json['couponId'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    allAmount = json['allAmount'];
    productDiscount = json['productDiscount'];
    totalAmount = json['totalAmount'];
    orderId = json['orderId'];
    orderType = json['orderType'];
    deliveryCharges = json['deliveryCharges'];
    isPaid = json['isPaid'];
    shippingAddress = json['shippingAddress'] != null ? ShippingAddress.fromJson(json['shippingAddress']) : null;
    isRated = json['isRated'];
    rating = json['rating'];
    paymentStatus = json['paymentStatus'];
    deliveryStatus = json['deliveryStatus'];
    invoice = json['invoice'];
    couponDiscount = json['couponDiscount'];
    purchaseDate = json['purchaseDate'];
    deliveredDate = json['deliveredDate'];
    returnDate = json['returnDate'];
    dispatchDate = json['dispatchDate'];
    cancelDate = json['cancelDate'];
    invoiceDate = json['invoiceDate'];
    platform = json['platform'];
    isReturn = json['isReturn'];
    awbNumber = json['awbNumber'];
    trackingId = json['trackingId'];
    trackingLink = json['trackingLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['storeOrderId'] = storeOrderId;
    data['couponId'] = couponId;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['allAmount'] = allAmount;
    data['productDiscount'] = productDiscount;
    data['totalAmount'] = totalAmount;
    data['orderId'] = orderId;
    data['orderType'] = orderType;
    data['deliveryCharges'] = deliveryCharges;
    data['isPaid'] = isPaid;
    if (shippingAddress != null) {
      data['shippingAddress'] = shippingAddress!.toJson();
    }
    data['isRated'] = isRated;
    data['rating'] = rating;
    data['paymentStatus'] = paymentStatus;
    data['deliveryStatus'] = deliveryStatus;
    data['invoice'] = invoice;
    data['couponDiscount'] = couponDiscount;
    data['purchaseDate'] = purchaseDate;
    data['deliveredDate'] = deliveredDate;
    data['returnDate'] = returnDate;
    data['dispatchDate'] = dispatchDate;
    data['cancelDate'] = cancelDate;
    data['invoiceDate'] = invoiceDate;
    data['platform'] = platform;
    data['isReturn'] = isReturn;
    data['awbNumber'] = awbNumber;
    data['trackingId'] = trackingId;
    data['trackingLink'] = trackingLink;
    return data;
  }
}

class Products {
  String? id;
  String? title;
  String? featuredImage;
  String? quantity;
  String? slug;
  int? salePrice;
  String? productAmount;
  List<String>? images;

  Products({
    this.id,
    this.title,
    this.featuredImage,
    this.quantity,
    this.slug,
    this.salePrice,
    this.productAmount,
    this.images,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    featuredImage = json['featuredImage'];
    quantity = json['quantity'];
    slug = json['slug'];
    salePrice = json['salePrice'];
    productAmount = json['productAmount'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['featuredImage'] = featuredImage;
    data['quantity'] = quantity;
    data['slug'] = slug;
    data['salePrice'] = salePrice;
    data['productAmount'] = productAmount;
    data['images'] = images;
    return data;
  }
}

class ShippingAddress {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? streetAddress;
  String? city;
  String? state;
  String? country;
  String? pinCode;

  ShippingAddress({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.streetAddress,
    this.city,
    this.state,
    this.country,
    this.pinCode,
  });

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    streetAddress = json['streetAddress'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pinCode = json['pinCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['streetAddress'] = streetAddress;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['pinCode'] = pinCode;
    return data;
  }
}
