class OrderIdGeneration {
  bool? status;
  Data? data;
  String? msg;

  OrderIdGeneration({this.status, this.data, this.msg});

  OrderIdGeneration.fromJson(Map<String, dynamic> json) {
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
  String? appId;
  String? appSecret;
  String? userId;
  int? amount;
  String? orderId;
  String? paymentSessionId;

  Data(
      {this.appId,
      this.appSecret,
      this.userId,
      this.amount,
      this.orderId,
      this.paymentSessionId});

  Data.fromJson(Map<String, dynamic> json) {
    appId = json['appId'];
    appSecret = json['appSecret'];
    userId = json['userId'];
    amount = json['amount'];
    orderId = json['orderId'];
    paymentSessionId = json['paymentSessionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appId'] = appId;
    data['appSecret'] = appSecret;
    data['userId'] = userId;
    data['amount'] = amount;
    data['orderId'] = orderId;
    data['paymentSessionId'] = paymentSessionId;
    return data;
  }
}
