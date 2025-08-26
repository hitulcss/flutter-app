class StoreOderIdGenerate {
  bool? status;
  StoreOderIdGenerateData? data;
  String? msg;

  StoreOderIdGenerate({this.status, this.data, this.msg});

  StoreOderIdGenerate.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? StoreOderIdGenerateData.fromJson(json['data']) : null;
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

class StoreOderIdGenerateData {
  String? orderId;
  // int? orderAmount;
  String? sessionId;
  String? orderStatus;

  StoreOderIdGenerateData({this.orderId, 
  // this.orderAmount
   this.sessionId, this.orderStatus});

  StoreOderIdGenerateData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    // orderAmount = json['orderAmount'];
    sessionId = json['sessionId'];
    orderStatus = json['orderStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    // data['orderAmount'] = orderAmount;
    data['sessionId'] = sessionId;
    data['orderStatus'] = orderStatus;
    return data;
  }
}
