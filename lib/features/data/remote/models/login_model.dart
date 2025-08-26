// class LoginModel {
//   LoginModel({
//     required this.status,
//     required this.data,
//     required this.msg,
//   });

//   final bool status;
//   final LoginDataModel data;
//   final String msg;

//   factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
//         status: json["status"],
//         data: LoginDataModel.fromJson(json["data"]),
//         msg: json["msg"],
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": data.toJson(),
//         "msg": msg,
//       };
// }

// class LoginDataModel {
//   LoginDataModel({
//     required this.refreshTokenAuth,
//     required this.accessToken,
//     required this.language,
//     required this.stream,
//     required this.username,
//     required this.email,
//     required this.phoneNumber,
//     required this.userId,
//     required this.fullName,
//     required this.profilePhoto,
//     required this.address,
//     required this.mobileVerified,
//     required this.enrollId,
//     required this.myReferralCode,
//   });

//   final String refreshTokenAuth;
//   final String accessToken;
//   final String language;
//   final List<String> stream;
//   final String username;
//   final String email;
//   final String phoneNumber;
//   final String userId;
//   final String fullName;
//   final String profilePhoto;
//   final String address;
//   final bool mobileVerified;
//   final String enrollId;
//   final String myReferralCode;
//   factory LoginDataModel.fromJson(Map<String, dynamic> json) => LoginDataModel(
//         refreshTokenAuth: json["RefreshTokenAuth"],
//         accessToken: json["accessToken"],
//         language: json["language"],
//         stream: List<String>.from(json["stream"].map((x) => x)),
//         username: json["username"],
//         email: json["email"],
//         phoneNumber: json["phoneNumber"],
//         userId: json["userID"],
//         fullName: json["FullName"],
//         profilePhoto: json["profilePhoto"],
//         address: json["Address"],
//         mobileVerified: json["mobileVerified"],
//         enrollId: json['enrollId'],
//         myReferralCode: json['myReferralCode'],
//       );

//   Map<String, dynamic> toJson() => {
//         "RefreshTokenAuth": refreshTokenAuth,
//         "accessToken": accessToken,
//         "language": language,
//         "stream": List<dynamic>.from(stream.map((x) => x)),
//         "username": username,
//         "email": email,
//         "phoneNumber": phoneNumber,
//         "userID": userId,
//         "FullName": fullName,
//         "profilePhoto": profilePhoto,
//         "Address": address,
//         "mobileVerified": mobileVerified,
//         'enrollId': enrollId,
//         'myReferralCode': myReferralCode,
//       };
// }
class LoginModel {
  bool? status;
  LoginModelData? data;
  String? msg;

  LoginModel({this.status, this.data, this.msg});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? LoginModelData.fromJson(json['data']) : null;
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

class LoginModelData {
  String? refreshToken;
  String? otpLength;

  LoginModelData({this.refreshToken, this.otpLength});

  LoginModelData.fromJson(Map<String, dynamic> json) {
    refreshToken = json['refreshToken'];
    otpLength = json['otpLength'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['refreshToken'] = refreshToken;
    data['otpLength'] = otpLength;
    return data;
  }
}

