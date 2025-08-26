class AddToCart {
  bool? status;
  List<Data>? data;
  String? msg;

  AddToCart({this.status, this.data, this.msg});

  AddToCart.fromJson(Map<String, dynamic> json) {
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
  CartDetails? cartDetails;
  BatchDetails? batchDetails;

  Data({this.cartDetails, this.batchDetails});

  Data.fromJson(Map<String, dynamic> json) {
    cartDetails = json['cartDetails'] != null
        ? CartDetails.fromJson(json['cartDetails'])
        : null;
    batchDetails = json['batchDetails'] != null
        ? BatchDetails.fromJson(json['batchDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cartDetails != null) {
      data['cartDetails'] = cartDetails!.toJson();
    }
    if (batchDetails != null) {
      data['batchDetails'] = batchDetails!.toJson();
    }
    return data;
  }
}

class CartDetails {
  String? createdAt;
  String? user;
  String? batchId;
  String? amount;
  bool? isActive;
  String? sId;

  CartDetails(
      {this.createdAt,
      this.user,
      this.batchId,
      this.amount,
      this.isActive,
      this.sId});

  CartDetails.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    user = json['user'];
    batchId = json['batch_id'];
    amount = json['Amount'];
    isActive = json['is_active'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['user'] = user;
    data['batch_id'] = batchId;
    data['Amount'] = amount;
    data['is_active'] = isActive;
    data['_id'] = sId;
    return data;
  }
}

class BatchDetails {
  String? sId;
  String? user;
  String? batchName;
  String? examType;
  List<String>? student;
  String? subject;
  List<String>? teacher;
  String? startingDate;
  String? endingDate;
  String? mode;
  String? materials;
  String? language;
  String? charges;
  String? discount;
  String? description;
  String? remark;
  String? validity;
  bool? isActive;
  String? courseReview;
  String? createdAt;

  BatchDetails(
      {this.sId,
      this.user,
      this.batchName,
      this.examType,
      this.student,
      this.subject,
      this.teacher,
      this.startingDate,
      this.endingDate,
      this.mode,
      this.materials,
      this.language,
      this.charges,
      this.discount,
      this.description,
      this.remark,
      this.validity,
      this.isActive,
      this.courseReview,
      this.createdAt,
      });

  BatchDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    batchName = json['batch_name'];
    examType = json['exam_type'];
    student = json['student'].cast<String>();
    subject = json['subject'];
    teacher = json['teacher'].cast<String>();
    startingDate = json['starting_date'];
    endingDate = json['ending_date'];
    mode = json['mode'];
    materials = json['materials'];
    language = json['language'];
    charges = json['charges'];
    discount = json['discount'];
    description = json['description'];
    remark = json['remark'];
    validity = json['validity'];
    isActive = json['is_active'];
    courseReview = json['course_review'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['batch_name'] = batchName;
    data['exam_type'] = examType;
    data['student'] = student;
    data['subject'] = subject;
    data['teacher'] = teacher;
    data['starting_date'] = startingDate;
    data['ending_date'] = endingDate;
    data['mode'] = mode;
    data['materials'] = materials;
    data['language'] = language;
    data['charges'] = charges;
    data['discount'] = discount;
    data['description'] = description;
    data['remark'] = remark;
    data['validity'] = validity;
    data['is_active'] = isActive;
    data['course_review'] = courseReview;
    data['created_at'] = createdAt;
    return data;
  }
}
