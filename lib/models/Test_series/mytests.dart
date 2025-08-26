class MyTestsModel {
  bool? status;
  List<Data>? data;
  String? msg;

  MyTestsModel({this.status, this.data, this.msg});

  MyTestsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  String? sId;
  String? user;
  TestseriesId? testseriesId;
  int? amount;
  bool? isActive;
  bool? isPaid;
  String? createdAt;
  String? updatedAt;

  Progress? progress;

  Data({
    this.sId,
    this.user,
    this.testseriesId,
    this.amount,
    this.isActive,
    this.isPaid,
    this.createdAt,
    this.updatedAt,
    this.progress,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    testseriesId = json['testseries_id'] != null ? TestseriesId.fromJson(json['testseries_id']) : null;
    amount = json['amount'];
    isActive = json['is_active'];
    isPaid = json['is_paid'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    progress = json['progress'] != null ? Progress.fromJson(json['progress']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    if (testseriesId != null) {
      data['testseries_id'] = testseriesId!.toJson();
    }
    data['amount'] = amount;
    data['is_active'] = isActive;
    data['is_paid'] = isPaid;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (progress != null) {
      data['progress'] = progress!.toJson();
    }
    return data;
  }
}

class TestseriesId {
  String? sId;
  String? user;
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
  String? createdAt;

  TestseriesId({
    this.sId,
    this.user,
    this.testseriesName,
    this.examType,
    this.student,
    this.teacher,
    this.startingDate,
    this.charges,
    this.discount,
    this.banner,
    this.language,
    this.stream,
    this.remark,
    this.noOfTest,
    this.validity,
    this.isActive,
    this.createdAt,
  });

  TestseriesId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
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
    createdAt = json['created_at'];
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
    data['no_of_test'] = noOfTest;
    data['validity'] = validity;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
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

class Progress {
  String? percentage;
  String? value;

  Progress({this.percentage, this.value});

  Progress.fromJson(Map<String, dynamic> json) {
    percentage = json['percentage'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['percentage'] = percentage;
    data['value'] = value;
    return data;
  }
}
