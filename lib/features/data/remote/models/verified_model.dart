class VerifedModel {
  bool? status;
  VerifedModelData? data;
  String? msg;

  VerifedModel({this.status, this.data, this.msg});

  VerifedModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? VerifedModelData.fromJson(json['data']) : null;
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

class VerifedModelData {
  String? token;
  String? id;
  String? enrollId;
  String? name;
  String? email;
  String? mobileNumber;
  String? profilePhoto;
  List<String>? stream;
  String? myReferralCode;
  String? language;
  bool? isActive;
  bool? isNew;
  String? address;
  bool? isVerified;
  CurrentCategory? currentCategory;

  VerifedModelData({
    this.token,
    this.id,
    this.enrollId,
    this.name,
    this.email,
    this.mobileNumber,
    this.profilePhoto,
    this.stream,
    this.myReferralCode,
    this.language,
    this.isActive,
    this.isNew,
    this.address,
    this.isVerified,
    this.currentCategory,
  });

  VerifedModelData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    address = json["Address"];
    enrollId = json['enrollId'];
    name = json['name'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];
    profilePhoto = json['profilePhoto'];
    stream = json['stream'].cast<String>();
    myReferralCode = json['myReferralCode'];
    language = json['language'];
    isActive = json['is_active'];
    isNew = json['isNew'];
    isVerified = json['isVerified'];
    currentCategory = json['currentCategory'] != null ? CurrentCategory.fromJson(json['currentCategory']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['id'] = id;
    data['enrollId'] = enrollId;
    data['name'] = name;
    data["Address"] = address;
    data['email'] = email;
    data['mobileNumber'] = mobileNumber;
    data['profilePhoto'] = profilePhoto;
    data['stream'] = stream;
    data['myReferralCode'] = myReferralCode;
    data['language'] = language;
    data['is_active'] = isActive;
    data['isNew'] = isNew;
    data['isVerified'] = isVerified;
    if (currentCategory != null) {
      data['currentCategory'] = currentCategory!.toJson();
    }
    return data;
  }
}

class CurrentCategory {
  String? title;
  String? id;

  CurrentCategory({this.title, this.id});

  CurrentCategory.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['id'] = id;
    return data;
  }
}
