class GoogleAuthModel {
  GoogleAuthModel({
    required this.status,
    required this.data,
    required this.msg,
  });

  final bool status;
  final GoogleAuthDataModel data;
  final String msg;

  factory GoogleAuthModel.fromJson(Map<String, dynamic> json) => GoogleAuthModel(
        status: json["status"],
        data: GoogleAuthDataModel.fromJson(json["data"]),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "msg": msg,
      };
}

class GoogleAuthDataModel {
  GoogleAuthDataModel({
    required this.accessToken,
    required this.verificationToken,
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.createdAt,
    required this.profilePhoto,
    required this.userEmailVerified,
    required this.address,
    required this.signinType,
    required this.phoneNumber,
    required this.userMobileNumberVerified,
    required this.language,
    required this.stream,
    required this.verified,
    required this.enrollId,
    required this.myReferralCode
  });

  final String accessToken;
  final String verificationToken;
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String createdAt;
  final String profilePhoto;
  final bool userEmailVerified;
  final String address;
  final String signinType;
  final String phoneNumber;
  final bool userMobileNumberVerified;
  final String language;
  final List<String> stream;
  final bool verified;
  final String enrollId;
  final String myReferralCode;

  factory GoogleAuthDataModel.fromJson(Map<String, dynamic> json) => GoogleAuthDataModel(
        accessToken: json["accessToken"],
        verificationToken: json["verification_token"],
        id: json["id"],
        username: json["username"],
        fullName: json["FullName"],
        email: json["email"],
        createdAt: json["created_at"],
        profilePhoto: json["profilePhoto"],
        userEmailVerified: json["userEmailVerified"],
        address: json["Address"],
        signinType: json["signinType"],
        phoneNumber: json["phoneNumber"],
        userMobileNumberVerified: json["userMobileNumberVerified"],
        language: json["Language"],
        stream: List<String>.from(json["stream"].map((x) => x)),
        verified: json["verified"],
        enrollId: json['enrollId'],
        myReferralCode: json['myReferralCode'],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "verification_token": verificationToken,
        "id": id,
        "username": username,
        "FullName": fullName,
        "email": email,
        "created_at": createdAt,
        "profilePhoto": profilePhoto,
        "userEmailVerified": userEmailVerified,
        "Address": address,
        "signinType": signinType,
        "phoneNumber": phoneNumber,
        "userMobileNumberVerified": userMobileNumberVerified,
        "Language": language,
        "stream": List<dynamic>.from(stream.map((x) => x)),
        "verified": verified,
        "myReferralCode": myReferralCode,
        'enrollId': enrollId
      };
}
