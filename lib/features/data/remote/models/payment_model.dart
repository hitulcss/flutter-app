class PaymentModel {
  final String orderId;
  final String description;
  final String mobileNumber;
  final String userName;
  final String userEmail;
  final String batchId;
  final String price;
  final bool success;
  final bool isCoinApplied;
  final String paymentid;

  PaymentModel({
    required this.paymentid,
    required this.orderId,
    required this.description,
    required this.mobileNumber,
    required this.userName,
    required this.userEmail,
    required this.batchId,
    required this.price,
    required this.success,
    required this.isCoinApplied,
  });

  Map<String, dynamic> toJson() => {
        "payment_id":paymentid,
        "pay_order_id": orderId,
        "description": description,
        "mobileNumber": mobileNumber,
        "userName": userName,
        "userEmail": userEmail,
        "batchId": batchId,
        "price": price,
        "success": success,
        "isCoinApplied": isCoinApplied
      };
}
