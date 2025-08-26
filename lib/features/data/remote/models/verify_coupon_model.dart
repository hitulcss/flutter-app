class VerifyCouponModel {
  bool? status;
  Data? data;
  String? msg;

  VerifyCouponModel({this.status, this.data, this.msg});

  VerifyCouponModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  String? id;
  String? couponCode;
  String? couponType;
  int? couponValue;
  bool? isActive;

  Data({
    this.id,
    this.couponCode,
    this.couponType,
    this.couponValue,
    this.isActive,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    couponCode = json['couponCode'];
    couponType = json['couponType'];
    couponValue = json['couponValue'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data['couponCode'] = couponCode;
    data['couponType'] = couponType;
    data['couponValue'] = couponValue;
    data['is_active'] = isActive;
    return data;
  }
}
