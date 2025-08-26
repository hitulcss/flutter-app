class GoogleSignIn {
  bool? status;
  Data? data;
  String? msg;

  GoogleSignIn({this.status, this.data, this.msg});

  GoogleSignIn.fromJson(Map<String, dynamic> json) {
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
  String? accessToken;
  String? verificationToken;
  String? id;
  String? username;
  String? fullName;
  String? email;
  String? createdAt;
  String? profilePhoto;
  bool? userEmailVerified;
  String? address;
  String? signinType;
  String? phoneNumber;
  bool? userMobileNumberVerified;
  String? language;
  List? stream;
  late bool verified;

  Data(
      {this.accessToken,
      this.verificationToken,
      this.id,
      this.username,
      this.fullName,
      this.email,
      this.createdAt,
      this.profilePhoto,
      this.userEmailVerified,
      this.address,
      this.signinType,
      this.phoneNumber,
      this.userMobileNumberVerified,
      this.language,
      this.stream,
      required this.verified});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    verificationToken = json['verification_token'];
    id = json['id'];
    username = json['username'];
    fullName = json['FullName'];
    email = json['email'];
    createdAt = json['created_at'];
    profilePhoto = json['profilePhoto'];
    userEmailVerified = json['userEmailVerified'];
    address = json['Address'];
    signinType = json['signinType'];
    phoneNumber = json['phoneNumber'];
    userMobileNumberVerified = json['userMobileNumberVerified'];
    language = json['language'];
    stream = json['stream'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['verification_token'] = verificationToken;
    data['id'] = id;
    data['username'] = username;
    data['FullName'] = fullName;
    data['email'] = email;
    data['created_at'] = createdAt;
    data['profilePhoto'] = profilePhoto;
    data['userEmailVerified'] = userEmailVerified;
    data['Address'] = address;
    data['signinType'] = signinType;
    data['phoneNumber'] = phoneNumber;
    data['userMobileNumberVerified'] = userMobileNumberVerified;
    data['language'] = language;
    data['stream'] = stream;
    data['verified'] = verified;
    return data;
  }
}
