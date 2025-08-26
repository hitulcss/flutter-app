import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';

class CoursesModel {
  CoursesModel({
    required this.status,
    required this.data,
    required this.msg,
  });

  final bool status;
  final List<CoursesDataModel> data;
  final String msg;

  factory CoursesModel.fromJson(Map<String, dynamic> json) => CoursesModel(
        status: json["status"],
        data: List<CoursesDataModel>.from(json["data"].map((x) => CoursesDataModel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "msg": msg,
      };
}

class CoursesDataModel {
  CoursesDataModel({
    required this.id,
    required this.batchName,
    required this.examType,
    required this.student,
    required this.teacher,
    required this.startingDate,
    required this.endingDate,
    required this.mode,
    required this.materials,
    required this.language,
    required this.charges,
    required this.discount,
    required this.description,
    required this.banner,
    required this.remark,
    required this.demoVideo,
    required this.validity,
    required this.isActive,
    required this.courseReview,
    required this.createdAt,
    required this.isPaid,
    required this.stream,
    required this.isCoinApplicable,
    required this.batchFeatureUrl,
    required this.maxAllowedCoins,
    required this.subCategory,
  });

  String id;
  String batchName;
  String examType;
  List<String> student;
  List<Teacher> teacher;
  DateTime startingDate;
  DateTime endingDate;
  String mode;
  String materials;
  String language;
  String charges;
  String discount;
  String batchFeatureUrl;
  String description;
  List<Banner> banner;
  String remark;
  List<DemoVideo> demoVideo;
  String validity;
  bool isActive;
  bool isPaid;
  String courseReview;
  bool isCoinApplicable;
  String maxAllowedCoins;
  String stream;
  String subCategory;
  String createdAt;

  factory CoursesDataModel.fromJson(Map<String, dynamic> json) => CoursesDataModel(
        id: json["_id"],
        batchName: json["batch_name"],
        examType: json["exam_type"],
        student: List<String>.from(json["student"].map((x) => x)),
        teacher: List<Teacher>.from(json["teacher"].map((x) => Teacher.fromJson(x))),
        startingDate: DateTime.parse(json["starting_date"]),
        endingDate: DateTime.parse(json["ending_date"]),
        mode: json["mode"],
        materials: json["materials"],
        language: json["language"],
        charges: json["charges"],
        discount: json["discount"],
        description: json["description"],
        banner: List<Banner>.from(json["banner"].map((x) => Banner.fromJson(x))),
        remark: json["remark"],
        demoVideo: List<DemoVideo>.from(json["demoVideo"].map((x) => DemoVideo.fromJson(x))),
        validity: json["validity"],
        isActive: json["is_active"],
        isPaid: json['isPaid'],
        stream: json["stream"],
        courseReview: json["course_review"],
        createdAt: json["created_at"],
        isCoinApplicable: json['isCoinApplicable'],
        maxAllowedCoins: json['maxAllowedCoins'],
        batchFeatureUrl: json['batchFeatureUrl'],
        subCategory: json['subCategory'],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "batch_name": batchName,
        "exam_type": examType,
        "student": List<dynamic>.from(student.map((x) => x)),
        "teacher": List<dynamic>.from(teacher.map((x) => x.toJson())),
        "starting_date": "${startingDate.year.toString().padLeft(4, '0')}-${startingDate.month.toString().padLeft(2, '0')}-${startingDate.day.toString().padLeft(2, '0')}",
        "ending_date": "${endingDate.year.toString().padLeft(4, '0')}-${endingDate.month.toString().padLeft(2, '0')}-${endingDate.day.toString().padLeft(2, '0')}",
        "mode": mode,
        "materials": materials,
        "language": language,
        "charges": charges,
        "discount": discount,
        "description": description,
        "banner": List<dynamic>.from(banner.map((x) => x.toJson())),
        "remark": remark,
        "demoVideo": List<dynamic>.from(demoVideo.map((x) => x.toJson())),
        "validity": validity,
        "is_active": isActive,
        "stream": stream,
        "isPaid": isPaid,
        "course_review": courseReview,
        "created_at": createdAt,
        "batchFeatureUrl": batchFeatureUrl,
        "maxAllowedCoins": maxAllowedCoins,
        "isCoinApplicable": isCoinApplicable,
        "subCategory":subCategory
      };
}

class Banner {
  Banner({
    required this.fileLoc,
    required this.fileName,
    required this.fileSize,
  });

  final String fileLoc;
  final String fileName;
  final String fileSize;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        fileLoc: json["fileLoc"],
        fileName: json["fileName"],
        fileSize: json["fileSize"],
      );

  Map<String, dynamic> toJson() => {
        "fileLoc": fileLoc,
        "fileName": fileName,
        "fileSize": fileSize,
      };
}

class Teacher {
  Teacher({
    required this.id,
    required this.fullName,
    required this.profilePhoto,
  });

  final String id;
  final String fullName;
  final String profilePhoto;

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        id: json["_id"],
        fullName: json["FullName"],
        profilePhoto: json["profilePhoto"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "FullName": fullName,
        "profilePhoto": profilePhoto,
      };
}
