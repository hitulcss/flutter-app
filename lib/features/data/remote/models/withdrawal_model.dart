class WithdrawalRequestModel {
  bool? status;
  WithdrawalRequestModelData? data;
  String? msg;

  WithdrawalRequestModel({this.status, this.data, this.msg});

  WithdrawalRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? WithdrawalRequestModelData.fromJson(json['data']) : null;
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

class WithdrawalRequestModelData {
  String? user;
  String? upiId;
  String? amount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? sId;

  WithdrawalRequestModelData({
    this.user,
    this.upiId,
    this.amount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.sId,
  });

  WithdrawalRequestModelData.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    upiId = json['upiId'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['upiId'] = upiId;
    data['amount'] = amount;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['_id'] = sId;
    return data;
  }
}
