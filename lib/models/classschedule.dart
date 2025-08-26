import 'dart:convert';

import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';

class ClassSchedulermodel {
  bool? status;
  List<ClassScheduleModel>? data;
  String? msg;

  ClassSchedulermodel({this.status, this.data, this.msg});

  ClassSchedulermodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ClassScheduleModel>[];
      json['data'].forEach((v) {
        data!.add(ClassScheduleModel.fromMap(v));
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

class ClassScheduleModel {
    String? id;
    String? userAdmin;
    String? batch;
    String? lectureType;
    String? lectureTitle;
    String? description;
    List<String>? teacher;
    String? subject;
    String? link;
    String? liveOrRecorded;
    String? startingDate;
    String? endingDate;
    Material? material;
    File? dpp;
    String? ytLiveChatId;
    String? createdAt;
    String? language;
    bool? isActive;
    String? commonName;
    String? socketUrl;
    String? banner;
    bool? isCommentAllowed;
    BatchDetails? batchDetails;
    RoomDetails? roomDetails;

    ClassScheduleModel({
        this.id,
        this.userAdmin,
        this.batch,
        this.lectureType,
        this.lectureTitle,
        this.description,
        this.teacher,
        this.subject,
        this.link,
        this.liveOrRecorded,
        this.startingDate,
        this.endingDate,
        this.material,
        this.dpp,
        this.ytLiveChatId,
        this.createdAt,
        this.language,
        this.isActive,
        this.commonName,
        this.socketUrl,
        this.banner,
        this.isCommentAllowed,
        this.batchDetails,
        this.roomDetails,
    });

    factory ClassScheduleModel.fromJson(String str) => ClassScheduleModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ClassScheduleModel.fromMap(Map<String, dynamic> json) => ClassScheduleModel(
        id: json["_id"],
        userAdmin: json["user_admin"],
        batch: json["batch"],
        lectureType: json["lecture_type"],
        lectureTitle: json["lecture_title"],
        description: json["description"],
        teacher: json["teacher"] == null ? [] : List<String>.from(json["teacher"]!.map((x) => x)),
        subject: json["subject"],
        link: json["link"],
        liveOrRecorded: json["LiveOrRecorded"],
        startingDate: json["starting_date"],
        endingDate: json["ending_date"],
        material: json["material"] == null ? null : Material.fromJson(json["material"]),
        dpp: json["dpp"] == null ? null : File.fromJson(json["dpp"]),
        ytLiveChatId: json["ytLiveChatId"],
        createdAt: json["created_at"],
        language: json["language"],
        isActive: json["isActive"],
        commonName: json["commonName"],
        socketUrl: json["socketUrl"],
        banner: json["banner"],
        isCommentAllowed: json["isCommentAllowed"],
        batchDetails: json["batchDetails"] == null ? null : BatchDetails.fromJson(json["batchDetails"]),
        roomDetails: json["roomDetails"] == null ? null : RoomDetails.fromJson(json["roomDetails"]),
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "user_admin": userAdmin,
        "batch": batch,
        "lecture_type": lectureType,
        "lecture_title": lectureTitle,
        "description": description,
        "teacher": teacher == null ? [] : List<dynamic>.from(teacher!.map((x) => x)),
        "subject": subject,
        "link": link,
        "LiveOrRecorded": liveOrRecorded,
        "starting_date": startingDate,
        "ending_date": endingDate,
        "material": material?.toJson(),
        "dpp": dpp?.toJson(),
        "ytLiveChatId": ytLiveChatId,
        "created_at": createdAt,
        "language": language,
        "isActive": isActive,
        "commonName": commonName,
        "socketUrl": socketUrl,
        "banner": banner,
        "isCommentAllowed": isCommentAllowed,
        "batchDetails": batchDetails?.toJson(),
        "roomDetails": roomDetails?.toJson(),
    };
}
