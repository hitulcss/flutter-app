
class RegisterModel {
  RegisterModel({
    required this.status,
    required this.data,
    required this.msg,
  });

  final bool status;
  final RegisterDataModel data;
  final String msg;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    status: json["status"],
    data: RegisterDataModel.fromJson(json["data"]),
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
    "msg": msg,
  };
}

class RegisterDataModel {
  RegisterDataModel({
    required this.token,
    required this.email,
    required this.mobileNumberVerificationOtp,
    required this.username,
    required this.userId,
    required this.id,
  });

  final String token;
  final String email;
  final int mobileNumberVerificationOtp;
  final String username;
  final String userId;
  final String id;

  factory RegisterDataModel.fromJson(Map<String, dynamic> json) => RegisterDataModel(
    token: json["token"],
    email: json["email"],
    mobileNumberVerificationOtp: json["mobileNumberVerificationOTP"],
    username: json["username"],
    userId: json["userId"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "email": email,
    "mobileNumberVerificationOTP": mobileNumberVerificationOtp,
    "username": username,
    "userId": userId,
    "_id": id,
  };
}
