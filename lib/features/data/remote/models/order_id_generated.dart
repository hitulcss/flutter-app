import 'dart:convert';

class OrderIdGenerated {
    bool? status;
    OrderIdGeneratedData? data;
    String? msg;

    OrderIdGenerated({
        this.status,
        this.data,
        this.msg,
    });

    OrderIdGenerated copyWith({
        bool? status,
        OrderIdGeneratedData? data,
        String? msg,
    }) => 
        OrderIdGenerated(
            status: status ?? this.status,
            data: data ?? this.data,
            msg: msg ?? this.msg,
        );

    factory OrderIdGenerated.fromJson(String str) => OrderIdGenerated.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory OrderIdGenerated.fromMap(Map<String, dynamic> json) => OrderIdGenerated(
        status: json["status"],
        data: json["data"] == null ? null : OrderIdGeneratedData.fromMap(json["data"]),
        msg: json["msg"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
        "msg": msg,
    };
}

class OrderIdGeneratedData {
    String? id;
    String? genTxnId;
    String? txnId;
    String? token;
    String? hash;
    String? userOrderId;
    String? orderId;
    String? paymentUrl;

    OrderIdGeneratedData({
        this.id,
        this.genTxnId,
        this.txnId,
        this.token,
        this.hash,
        this.userOrderId,
        this.orderId,
        this.paymentUrl,
    });

    OrderIdGeneratedData copyWith({
        String? id,
        String? genTxnId,
        String? txnId,
        String? token,
        String? hash,
        String? userOrderId,
        String? orderId,
        String? paymentUrl,
    }) => 
        OrderIdGeneratedData(
            id: id ?? this.id,
            genTxnId: genTxnId ?? this.genTxnId,
            txnId: txnId ?? this.txnId,
            token: token ?? this.token,
            hash: hash ?? this.hash,
            userOrderId: userOrderId ?? this.userOrderId,
            orderId: orderId ?? this.orderId,
            paymentUrl: paymentUrl ?? this.paymentUrl,
        );

    factory OrderIdGeneratedData.fromJson(String str) => OrderIdGeneratedData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory OrderIdGeneratedData.fromMap(Map<String, dynamic> json) => OrderIdGeneratedData(
        id: json["id"],
        genTxnId: json["genTxnId"],
        txnId: json["txnId"],
        token: json["token"],
        hash: json["hash"],
        userOrderId: json["userOrderId"],
        orderId: json["orderId"],
        paymentUrl: json["paymentUrl"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "genTxnId": genTxnId,
        "txnId": txnId,
        "token": token,
        "hash": hash,
        "userOrderId": userOrderId,
        "orderId": orderId,
        "paymentUrl": paymentUrl,
    };
}
