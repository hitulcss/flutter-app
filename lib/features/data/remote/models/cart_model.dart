
// class CartModel {
//   CartModel({
//     required this.status,
//     required this.data,
//     required this.msg,
//   });

//   final bool status;
//   final List<CartDataModel> data;
//   final String msg;

//   factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
//     status: json["status"],
//     data: List<CartDataModel>.from(json["data"].map((x) => CartDataModel.fromJson(x))),
//     msg: json["msg"],
//   );

//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//     "msg": msg,
//   };
// }

// class CartDataModel {
//   CartDataModel({
//     required this.cartId,
//     required this.createdAt,
//     required this.amount,
//     required this.isActive,
//     required this.batchDetails,
//   });

//   final String cartId;
//   final DateTime createdAt;
//   final String amount;
//   final bool isActive;
//   final BatchDetails batchDetails;

//   factory CartDataModel.fromJson(Map<String, dynamic> json) => CartDataModel(
//     cartId: json["cart_id"],
//     createdAt: DateTime.parse(json["created_at"]),
//     amount: json["Amount"],
//     isActive: json["is_active"],
//     batchDetails: BatchDetails.fromJson(json["batchDetails"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "cart_id": cartId,
//     "created_at": createdAt.toIso8601String(),
//     "Amount": amount,
//     "is_active": isActive,
//     "batchDetails": batchDetails.toJson(),
//   };
// }

// class BatchDetails {
//   BatchDetails({
//     required this.id,
//     required this.user,
//     required this.batchName,
//     required this.examType,
//     required this.student,
//     required this.subject,
//     required this.teacher,
//     required this.startingDate,
//     required this.endingDate,
//     required this.mode,
//     required this.materials,
//     required this.language,
//     required this.charges,
//     required this.discount,
//     required this.description,
//     required this.banner,
//     required this.remark,
//     required this.demoVideo,
//     required this.validity,
//     required this.isActive,
//     required this.courseReview,
//     required this.createdAt,
//   });

//   final String id;
//   final String user;
//   final String batchName;
//   final String examType;
//   final List<String> student;
//   final List<String> subject;
//   final List<String> teacher;
//   final DateTime startingDate;
//   final DateTime endingDate;
//   final String mode;
//   final String materials;
//   final String language;
//   final String charges;
//   final String discount;
//   final String description;
//   final List<Banner> banner;
//   final String remark;
//   final List<dynamic> demoVideo;
//   final String validity;
//   final bool isActive;
//   final String courseReview;
//   final String createdAt;

//   factory BatchDetails.fromJson(Map<String, dynamic> json) => BatchDetails(
//     id: json["_id"],
//     user: json["user"],
//     batchName: json["batch_name"],
//     examType: json["exam_type"],
//     student: List<String>.from(json["student"].map((x) => x)),
//     subject: List<String>.from(json["subject"].map((x) => x)),
//     teacher: List<String>.from(json["teacher"].map((x) => x)),
//     startingDate: DateTime.parse(json["starting_date"]),
//     endingDate: DateTime.parse(json["ending_date"]),
//     mode: json["mode"],
//     materials: json["materials"],
//     language: json["language"],
//     charges: json["charges"],
//     discount: json["discount"],
//     description: json["description"],
//     banner: List<Banner>.from(json["banner"].map((x) => Banner.fromJson(x))),
//     remark: json["remark"],
//     demoVideo: List<dynamic>.from(json["demoVideo"].map((x) => x)),
//     validity: json["validity"],
//     isActive: json["is_active"],
//     courseReview: json["course_review"],
//     createdAt: json["created_at"],
//   );

//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "user": user,
//     "batch_name": batchName,
//     "exam_type": examType,
//     "student": List<dynamic>.from(student.map((x) => x)),
//     "subject": List<dynamic>.from(subject.map((x) => x)),
//     "teacher": List<dynamic>.from(teacher.map((x) => x)),
//     "starting_date": "${startingDate.year.toString().padLeft(4, '0')}-${startingDate.month.toString().padLeft(2, '0')}-${startingDate.day.toString().padLeft(2, '0')}",
//     "ending_date": "${endingDate.year.toString().padLeft(4, '0')}-${endingDate.month.toString().padLeft(2, '0')}-${endingDate.day.toString().padLeft(2, '0')}",
//     "mode": mode,
//     "materials": materials,
//     "language": language,
//     "charges": charges,
//     "discount": discount,
//     "description": description,
//     "banner": List<dynamic>.from(banner.map((x) => x.toJson())),
//     "remark": remark,
//     "demoVideo": List<dynamic>.from(demoVideo.map((x) => x)),
//     "validity": validity,
//     "is_active": isActive,
//     "course_review": courseReview,
//     "created_at": createdAt,
//   };
// }

// class Banner {
//   Banner({
//     required this.fileLoc,
//     required this.fileName,
//     required this.fileSize,
//   });

//   final String fileLoc;
//   final String fileName;
//   final String fileSize;

//   factory Banner.fromJson(Map<String, dynamic> json) => Banner(
//     fileLoc: json["fileLoc"],
//     fileName: json["fileName"],
//     fileSize: json["fileSize"],
//   );

//   Map<String, dynamic> toJson() => {
//     "fileLoc": fileLoc,
//     "fileName": fileName,
//     "fileSize": fileSize,
//   };
// }
