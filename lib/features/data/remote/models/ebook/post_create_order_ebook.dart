class PostCreateOrderEbook {
  bool? status;
  PostCreateOrderEbookData? data;
  String? msg;

  PostCreateOrderEbook({this.status, this.data, this.msg});

  PostCreateOrderEbook.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? PostCreateOrderEbookData.fromJson(json['data']) : null;
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

class PostCreateOrderEbookData {
  String? orderId;
  int? orderAmount;
  String? sessionId;
  String? orderStatus;

  PostCreateOrderEbookData({this.orderId, this.orderAmount, this.sessionId, this.orderStatus});

  PostCreateOrderEbookData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderAmount = json['orderAmount'];
    sessionId = json['sessionId'];
    orderStatus = json['orderStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['orderAmount'] = orderAmount;
    data['sessionId'] = sessionId;
    data['orderStatus'] = orderStatus;
    return data;
  }
}
