class TestSeriesIdModel {
  bool? status;
  TestSeriesIdModelData? data;
  String? msg;

  TestSeriesIdModel({this.status, this.data, this.msg});

  TestSeriesIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? TestSeriesIdModelData.fromJson(json['data']) : null;
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

class TestSeriesIdModelData {
  String? sId;
  String? user;
  String? testseriesName;
  String? examType;
  List<String>? student;
  List<Teacher>? teacher;
  String? startingDate;
  String? charges;
  String? discount;
  String? description;
  List<Banner>? banner;
  String? language;
  String? stream;
  String? remark;
  int? noOfTest;
  String? validity;
  bool? isPaid;
  bool? isActive;
  bool? isCoinApplicable;
  String? maxAllowedCoins;
  String? createdAt;

  TestSeriesIdModelData({
    this.sId,
    this.user,
    this.testseriesName,
    this.examType,
    this.student,
    this.teacher,
    this.startingDate,
    this.charges,
    this.discount,
    this.description,
    this.banner,
    this.language,
    this.stream,
    this.remark,
    this.noOfTest,
    this.validity,
    this.isPaid,
    this.isActive,
    this.isCoinApplicable,
    this.maxAllowedCoins,
    this.createdAt,
  });

  TestSeriesIdModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    testseriesName = json['testseries_name'];
    examType = json['exam_type'];
    student = json['student'].cast<String>();
    if (json['teacher'] != null) {
      teacher = <Teacher>[];
      json['teacher'].forEach((v) {
        teacher!.add(Teacher.fromJson(v));
      });
    }
    startingDate = json['starting_date'];
    charges = json['charges'];
    discount = json['discount'];
    description = json['description'];
    if (json['banner'] != null) {
      banner = <Banner>[];
      json['banner'].forEach((v) {
        banner!.add(Banner.fromJson(v));
      });
    }
    language = json['language'];
    stream = json['stream'];
    remark = json['remark'];
    noOfTest = json['no_of_test'];
    validity = json['validity'];
    isPaid = json['isPaid'];
    isActive = json['is_active'];
    isCoinApplicable = json['isCoinApplicable'];
    maxAllowedCoins = json['maxAllowedCoins'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['testseries_name'] = testseriesName;
    data['exam_type'] = examType;
    data['student'] = student;
    if (teacher != null) {
      data['teacher'] = teacher!.map((v) => v.toJson()).toList();
    }
    data['starting_date'] = startingDate;
    data['charges'] = charges;
    data['discount'] = discount;
    data['description'] = description;
    if (banner != null) {
      data['banner'] = banner!.map((v) => v.toJson()).toList();
    }
    data['language'] = language;
    data['stream'] = stream;
    data['remark'] = remark;
    data['no_of_test'] = noOfTest;
    data['validity'] = validity;
    data['isPaid'] = isPaid;
    data['is_active'] = isActive;
    data['isCoinApplicable'] = isCoinApplicable;
    data['maxAllowedCoins'] = maxAllowedCoins;
    data['created_at'] = createdAt;
    return data;
  }
}

class Teacher {
  String? sId;
  String? fullName;
  String? profilePhoto;

  Teacher({this.sId, this.fullName, this.profilePhoto});

  Teacher.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['FullName'];
    profilePhoto = json['profilePhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['FullName'] = fullName;
    data['profilePhoto'] = profilePhoto;
    return data;
  }
}

class Banner {
  String? fileLoc;
  String? fileName;
  String? fileSize;

  Banner({this.fileLoc, this.fileName, this.fileSize});

  Banner.fromJson(Map<String, dynamic> json) {
    fileLoc = json['fileLoc'];
    fileName = json['fileName'];
    fileSize = json['fileSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileLoc'] = fileLoc;
    data['fileName'] = fileName;
    data['fileSize'] = fileSize;
    return data;
  }
}
