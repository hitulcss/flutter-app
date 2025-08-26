class CouponGetModel {
  bool? status;
  List<CouponGetModelData>? data;
  String? msg;

  CouponGetModel({this.status, this.data, this.msg});

  CouponGetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CouponGetModelData>[];
      json['data'].forEach((v) {
        data!.add(CouponGetModelData.fromJson(v));
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

class CouponGetModelData {
  String? id;
  String? couponCode;
  String? couponType;
  int? couponValue;
  String? expirationDate;
  bool? isActive;

  CouponGetModelData({
    this.id,
    this.couponCode,
    this.couponType,
    this.couponValue,
    this.expirationDate,
    this.isActive,
  });

  CouponGetModelData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    couponCode = json['couponCode'];
    couponType = json['couponType'];
    couponValue = json['couponValue'];
    expirationDate = json['expirationDate'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data['couponCode'] = couponCode;
    data['couponType'] = couponType;
    data['couponValue'] = couponValue;
    data['expirationDate'] = expirationDate;
    data['is_active'] = isActive;
    return data;
  }
}
