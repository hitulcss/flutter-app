class TestSeriesModel {
  bool? status;
  List<TestSeriesData>? data;
  String? msg;

  TestSeriesModel({this.status, this.data, this.msg});

  TestSeriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TestSeriesData>[];
      json['data'].forEach((v) {
        data!.add(TestSeriesData.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = msg;
    return data;
  }
}

class TestSeriesData {
  String? sId;
  String? user;
  String? description;
  String? testseriesName;
  String? examType;
  List<String>? student;
  List<String>? teacher;
  String? startingDate;
  String? charges;
  String? discount;
  List<Banner>? banner;
  String? language;
  String? stream;
  String? remark;
  int? noOfTest;
  String? validity;
  bool? isActive;
  bool? isPaid;
  String? createdAt;
  bool? isCoinApplicable;
  String? maxAllowedCoins;

  TestSeriesData({
    this.sId,
    this.user,
    this.description,
    this.testseriesName,
    this.examType,
    this.student,
    this.teacher,
    this.startingDate,
    this.charges,
    this.discount,
    this.banner,
    this.isPaid,
    this.language,
    this.stream,
    this.remark,
    this.noOfTest,
    this.validity,
    this.isActive,
    this.createdAt,
    this.isCoinApplicable,
    this.maxAllowedCoins,
  });

  TestSeriesData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    description = json["description"];
    user = json['user'];
    testseriesName = json['testseries_name'];
    examType = json['exam_type'];
    student = json['student'].cast<String>();
    teacher = json['teacher'].cast<String>();
    startingDate = json['starting_date'];
    charges = json['charges'];
    discount = json['discount'];
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
    isActive = json['is_active'];
    isPaid = json['isPaid'];
    createdAt = json['created_at'];
    isCoinApplicable = json['isCoinApplicable'];
    maxAllowedCoins = json['maxAllowedCoins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['testseries_name'] = testseriesName;
    data['exam_type'] = examType;
    data['student'] = student;
    data['teacher'] = teacher;
    data['starting_date'] = startingDate;
    data['charges'] = charges;
    data['discount'] = discount;
    if (banner != null) {
      data['banner'] = banner!.map((v) => v.toJson()).toList();
    }
    data['language'] = language;
    data['stream'] = stream;
    data['remark'] = remark;
    data['isPaid'] = isPaid;
    data['no_of_test'] = noOfTest;
    data['validity'] = validity;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['maxAllowedCoins'] = maxAllowedCoins;
    data['isCoinApplicable'] = isCoinApplicable;
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
