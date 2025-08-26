class CourseModel {
  String? sId;
  String? user;
  String? batchName;
  String? examType;
  List<Student>? student;
  String? subject;
  List<Teacher>? teacher;
  String? startingDate;
  String? endingDate;
  String? mode;
  String? materials;
  String? language;
  String? charges;
  String? discount;
  String? description;
  String? banner;
  String? remark;
  String? validity;
  String? courseReview;
  String? createdAt;

  CourseModel({
    this.sId,
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
    this.banner,
    this.remark,
    this.validity,
    this.courseReview,
    this.createdAt,
  });

  CourseModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    batchName = json['batch_name'];
    examType = json['exam_type'];
    if (json['student'] != null) {
      student = <Student>[];
      json['student'].forEach((v) {
        student!.add(Student.fromJson(v));
      });
    }
    subject = json['subject'];
    if (json['teacher'] != null) {
      teacher = <Teacher>[];
      json['teacher'].forEach((v) {
        teacher!.add(Teacher.fromJson(v));
      });
    }
    startingDate = json['starting_date'];
    endingDate = json['ending_date'];
    mode = json['mode'];
    materials = json['materials'];
    language = json['language'];
    charges = json['charges'];
    discount = json['discount'];
    description = json['description'];
    banner = json['banner'];
    remark = json['remark'];
    validity = json['validity'];
    courseReview = json['course_review'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['batch_name'] = batchName;
    data['exam_type'] = examType;
    if (student != null) {
      data['student'] = student!.map((v) => v.toJson()).toList();
    }
    data['subject'] = subject;
    if (teacher != null) {
      data['teacher'] = teacher!.map((v) => v.toJson()).toList();
    }
    data['starting_date'] = startingDate;
    data['ending_date'] = endingDate;
    data['mode'] = mode;
    data['materials'] = materials;
    data['language'] = language;
    data['charges'] = charges;
    data['discount'] = discount;
    data['description'] = description;
    data['banner'] = banner;
    data['remark'] = remark;
    data['validity'] = validity;
    data['course_review'] = courseReview;
    data['created_at'] = createdAt;
    return data;
  }
}

class Student {
  String? sId;
  String? username;
  String? userId;
  String? fullName;
  String? password;
  String? email;
  String? createdAt;
  String? refreshToken;
  String? mobileNumber;
  int? emailVerificationOTP;
  int? mobileNumberVerificationOTP;
  String? otpcreatedDate;
  String? loginTrack;
  bool? mobileNumberVerified;
  String? language;

  Student({
    this.sId,
    this.username,
    this.userId,
    this.fullName,
    this.password,
    this.email,
    this.createdAt,
    this.refreshToken,
    this.mobileNumber,
    this.emailVerificationOTP,
    this.mobileNumberVerificationOTP,
    this.otpcreatedDate,
    this.loginTrack,
    this.mobileNumberVerified,
    this.language,
  });

  Student.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    userId = json['userId'];
    fullName = json['FullName'];
    password = json['password'];
    email = json['email'];
    createdAt = json['created_at'];
    refreshToken = json['RefreshToken'];
    mobileNumber = json['mobileNumber'];
    emailVerificationOTP = json['emailVerificationOTP'];
    mobileNumberVerificationOTP = json['mobileNumberVerificationOTP'];
    otpcreatedDate = json['otpcreatedDate'];
    loginTrack = json['LoginTrack'];
    mobileNumberVerified = json['mobileNumberVerified'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['username'] = username;
    data['userId'] = userId;
    data['FullName'] = fullName;
    data['password'] = password;
    data['email'] = email;
    data['created_at'] = createdAt;
    data['RefreshToken'] = refreshToken;
    data['mobileNumber'] = mobileNumber;
    data['emailVerificationOTP'] = emailVerificationOTP;
    data['mobileNumberVerificationOTP'] = mobileNumberVerificationOTP;
    data['otpcreatedDate'] = otpcreatedDate;
    data['LoginTrack'] = loginTrack;
    data['mobileNumberVerified'] = mobileNumberVerified;
    data['language'] = language;
    return data;
  }
}

class Teacher {
  String? sId;
  String? fullName;
  String? role;
  String? userId;
  int? mobileNumber;
  String? email;
  String? password;
  String? createdAt;

  Teacher({
    this.sId,
    this.fullName,
    this.role,
    this.userId,
    this.mobileNumber,
    this.email,
    this.password,
    this.createdAt,
  });

  Teacher.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['FullName'];
    role = json['Role'];
    userId = json['userId'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    password = json['password'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['FullName'] = fullName;
    data['Role'] = role;
    data['userId'] = userId;
    data['mobileNumber'] = mobileNumber;
    data['email'] = email;
    data['password'] = password;
    data['created_at'] = createdAt;
    return data;
  }
}
