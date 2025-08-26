
import 'dart:convert';

class MyOrdersModel {
  MyOrdersModel({
    required this.status,
    required this.data,
    required this.msg,
  });

  final bool status;
  final List<MyOrderDataModel> data;
  final String msg;

  factory MyOrdersModel.fromJson(Map<String, dynamic> json) => MyOrdersModel(
    status: json["status"],
    data: List<MyOrderDataModel>.from(json["data"].map((x) => MyOrderDataModel.fromJson(x))),
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "msg": msg,
  };
}

class MyOrderDataModel {
  MyOrderDataModel({
    required this.id,
    required this.user,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.description,
    required this.amount,
    required this.orderId,
    required this.userOrederId,
    required this.batchName,
    required this.transactionDate,
    required this.paymentId,
    required this.success,
    required this.invoice,
    required this.isEmi,
  });

  final String id;
  final String user;
  final String name;
  final String email;
  final String mobileNumber;
  final String description;
  final String amount;
  final String orderId;
  final String userOrederId;
  final String batchName;
  final String transactionDate;
  final String paymentId;
  final List<Invoice> invoice;
  final bool success;
  final bool isEmi;

  factory MyOrderDataModel.fromJson(Map<String, dynamic> json) => MyOrderDataModel(
    id: json["_id"],
    user: json["user"],
    name: json["name"],
    email: json["email"],
    mobileNumber: json["mobileNumber"],
    description: json["description"],
    amount: json["amount"],
    orderId: json["orderId"],
    userOrederId: json["userOrederId"],
    batchName: json["batch_name"],
    transactionDate: json["transactionDate"],
    paymentId: json["payment_id"],
    success: json["success"],
    invoice: List<Invoice>.from(json["invoice"].map((x) => Invoice.fromMap(x))),
     isEmi: json["isEmi"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "name": name,
    "email": email,
    "mobileNumber": mobileNumber,
    "description": description,
    "amount": amount,
    "orderId": orderId,
    "userOrederId": userOrederId,
    "batch_name": batchName,
    "transactionDate": transactionDate,
    "payment_id": paymentId,
    "success": success,
    "invoice": List<dynamic>.from(invoice.map((x) => x.toMap())),
    "isEmi": isEmi,
  };
}
class Invoice {
    String installmentNumber;
    String fileUrl;

    Invoice({
        required this.installmentNumber,
        required this.fileUrl,
    });

    factory Invoice.fromJson(String str) => Invoice.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Invoice.fromMap(Map<String, dynamic> json) => Invoice(
        installmentNumber: json["installmentNumber"],
        fileUrl: json["fileUrl"],
    );

    Map<String, dynamic> toMap() => {
        "installmentNumber": installmentNumber,
        "fileUrl": fileUrl,
    };
}
