class StoreOrderByID {
  bool? status;
  StoreOrderByIDData? data;
  String? msg;

  StoreOrderByID({this.status, this.data, this.msg});

  StoreOrderByID.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? StoreOrderByIDData.fromJson(json['data']) : null;
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

class StoreOrderByIDData {
  String? id;
  List<Products>? products;
  String? allAmount;
  String? productDiscount;
  String? totalAmount;
  String? couponId;
  String? orderId;
  bool? isPaid;
  ShippingAddress? shippingAddress;
  String? couponDiscount;
  String? paymentStatus;
  bool? isRated;
  String? rating;
  String? purchaseDate;
  String? deliveredDate;
  String? returnDate;
  String? dispatchDate;
  String? cancelDate;
  String? invoiceDate;
  String? invoice;
  String? orderType;
  String? deliveryCharges;
  String? deliveryStatus;
  String? awbNumber;
  String? trackingId;
  String? trackingLink;

  StoreOrderByIDData(
      {this.id,
      this.products,
      this.allAmount,
      this.productDiscount,
      this.totalAmount,
      this.couponId,
      this.orderId,
      this.isPaid,
      this.shippingAddress,
      this.couponDiscount,
      this.paymentStatus,
      this.isRated,
      this.rating,
      this.purchaseDate,
      this.deliveredDate,
      this.returnDate,
      this.dispatchDate,
      this.cancelDate,
      this.invoiceDate,
      this.invoice,
      this.orderType,
      this.deliveryCharges,
      this.deliveryStatus,
      this.awbNumber,
      this.trackingId,
      this.trackingLink});

  StoreOrderByIDData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    allAmount = json['allAmount'];
    productDiscount = json['productDiscount'];
    totalAmount = json['totalAmount'];
    couponId = json['couponId'];
    orderId = json['orderId'];
    isPaid = json['isPaid'];
    shippingAddress = json['shippingAddress'] != null
        ? ShippingAddress.fromJson(json['shippingAddress'])
        : null;
    couponDiscount = json['couponDiscount'];
    paymentStatus = json['paymentStatus'];
    isRated = json['isRated'];
    rating = json['rating'];
    purchaseDate = json['purchaseDate'];
    deliveredDate = json['deliveredDate'];
    returnDate = json['returnDate'];
    dispatchDate = json['dispatchDate'];
    cancelDate = json['cancelDate'];
    invoiceDate = json['invoiceDate'];
    invoice = json['invoice'];
    orderType = json['orderType'];
    deliveryCharges = json['deliveryCharges'];
    deliveryStatus = json['deliveryStatus'];
    awbNumber = json['awbNumber'];
    trackingId = json['trackingId'];
    trackingLink = json['trackingLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['allAmount'] = allAmount;
    data['productDiscount'] = productDiscount;
    data['totalAmount'] = totalAmount;
    data['couponId'] = couponId;
    data['orderId'] = orderId;
    data['isPaid'] = isPaid;
    if (shippingAddress != null) {
      data['shippingAddress'] = shippingAddress!.toJson();
    }
    data['couponDiscount'] = couponDiscount;
    data['paymentStatus'] = paymentStatus;
    data['isRated'] = isRated;
    data['rating'] = rating;
    data['purchaseDate'] = purchaseDate;
    data['deliveredDate'] = deliveredDate;
    data['returnDate'] = returnDate;
    data['dispatchDate'] = dispatchDate;
    data['cancelDate'] = cancelDate;
    data['invoiceDate'] = invoiceDate;
    data['invoice'] = invoice;
    data['orderType'] = orderType;
    data['deliveryCharges'] = deliveryCharges;
    data['deliveryStatus'] = deliveryStatus;
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
  String? salePrice;
  String? productAmount;

  Products(
      {this.id,
      this.title,
      this.featuredImage,
      this.quantity,
      this.salePrice,
      this.productAmount});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    featuredImage = json['featuredImage'];
    quantity = json['quantity'];
    salePrice = json['salePrice'];
    productAmount = json['productAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['featuredImage'] = featuredImage;
    data['quantity'] = quantity;
    data['salePrice'] = salePrice;
    data['productAmount'] = productAmount;
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

  ShippingAddress(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.streetAddress,
      this.city,
      this.state,
      this.country,
      this.pinCode});

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
