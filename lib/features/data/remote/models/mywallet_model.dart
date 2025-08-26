class MyWalletModel {
  bool? status;
  MyWalletModelData? data;
  String? msg;

  MyWalletModel({this.status, this.data, this.msg});

  MyWalletModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? MyWalletModelData.fromJson(json['data']) : null;
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

class MyWalletModelData {
  String? walletAmount;
  List<Transactions>? transactions;

  MyWalletModelData({this.walletAmount, this.transactions});

  MyWalletModelData.fromJson(Map<String, dynamic> json) {
    walletAmount = json['walletAmount'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['walletAmount'] = walletAmount;
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  String? action;
  String? reason;
  String? amount;
  String? dateTime;

  Transactions({this.action, this.reason, this.amount, this.dateTime});

  Transactions.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    reason = json['reason'];
    amount = json['amount'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action'] = action;
    data['reason'] = reason;
    data['amount'] = amount;
    data['dateTime'] = dateTime;
    return data;
  }
}
