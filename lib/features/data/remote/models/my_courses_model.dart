import 'dart:convert';

import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';

class MyCoursesModel {
  bool? status;
  List<MyCoursesDataModel>? data;
  String? msg;

  MyCoursesModel({this.status, this.data, this.msg});

  MyCoursesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <MyCoursesDataModel>[];
      json['data'].forEach((v) {
        data!.add(MyCoursesDataModel.fromJson(v));
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

class MyCoursesDataModel {
  String? myBatchId;
  String? batchId;
  String? description;
  Planner? planner;
  List<Banner>? banner;
  List<LectureDetails>? todayLecture;
  List<LectureDetails>? upcomingLecture;
  String? batchName;
  String? stream;
  String? shareLink;
  String? startingDate;
  String? endingdate;
  ShareUrl? shareUrl;
  String? language;
  int? daysLeft;
  String? expireDate;
  bool? isPaid;
  List<BatchFeature>? batchFeatures;

  MyCoursesDataModel({
    this.shareUrl,
    this.myBatchId,
    this.batchId,
    this.planner,
    this.description,
    this.banner,
    this.batchName,
    this.stream,
    this.shareLink,
    this.startingDate,
    this.endingdate,
    this.language,
    this.todayLecture,
    this.upcomingLecture,
    this.batchFeatures,
    this.daysLeft,
    this.expireDate,
    this.isPaid,
  });

  MyCoursesDataModel.fromJson(Map<String, dynamic> json) {
    shareUrl = json['shareUrl'] != null ? ShareUrl.fromJson(json['shareUrl']) : null;
    myBatchId = json['myBatchId'];
    description = json['description'];
    batchId = json['batchId'];
    if (json['banner'] != null) {
      banner = <Banner>[];
      json['banner'].forEach((v) {
        banner!.add(Banner.fromJson(v));
      });
    }
    planner = json['planner'] != null ? Planner.fromJson(json['planner']) : null;
    batchName = json['batchName'];
    stream = json['stream'];
    shareLink = json['shareLink'];
    startingDate = json['startingDate'];
    endingdate = json['endingdate'];
    language = json['language'];
    if (json['todayLecture'] != null) {
      todayLecture = <LectureDetails>[];
      json['todayLecture'].forEach((v) {
        todayLecture!.add(LectureDetails.fromJson(v));
      });
    }
    if (json['upcomingLecture'] != null) {
      upcomingLecture = <LectureDetails>[];
      json['upcomingLecture'].forEach((v) {
        upcomingLecture!.add(LectureDetails.fromJson(v));
      });
    }
    if (json['batchFeatures'] != null) {
      batchFeatures = <BatchFeature>[];
      json['batchFeatures'].forEach((v) {
        batchFeatures!.add(BatchFeature.fromMap(v));
      });
    }
    daysLeft = json['daysLeft'];
    expireDate = json['expireDate'];
    isPaid = json['isPaid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shareUrl'] = shareUrl;
    data['myBatchId'] = myBatchId;
    data['description'] = description;
    data['batchId'] = batchId;
    if (planner != null) {
      data['planner'] = planner!.toJson();
    }
    if (banner != null) {
      data['banner'] = banner!.map((v) => v.toJson()).toList();
    }
    if (todayLecture != null) {
      data['todayLecture'] = todayLecture!.map((v) => v.toJson()).toList();
    }
    if (upcomingLecture != null) {
      data['upcomingLecture'] = upcomingLecture!.map((v) => v.toJson()).toList();
    }
    if (batchFeatures != null) {
      data['batchFeatures'] = batchFeatures!.map((v) => v.toJson()).toList();
    }
    data['batchName'] = batchName;
    data['stream'] = stream;
    data['shareLink'] = shareLink;
    data['startingDate'] = startingDate;
    data['endingdate'] = endingdate;
    data['language'] = language;
    data['daysLeft'] = daysLeft;
    data['expireDate'] = expireDate;
    data['isPaid'] = isPaid;
    return data;
  }
}

class Banner {
  String? fileLoc;
  String? fileName;
  String? fileSize;
  String? bannerfileType;

  Banner({this.fileLoc, this.fileName, this.fileSize, this.bannerfileType});

  Banner.fromJson(Map<String, dynamic> json) {
    fileLoc = json['fileLoc'];
    fileName = json['fileName'];
    fileSize = json['fileSize'];
    bannerfileType = json['bannerfileType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileLoc'] = fileLoc;
    data['fileName'] = fileName;
    data['fileSize'] = fileSize;
    data['bannerfileType'] = bannerfileType;
    return data;
  }
}

class LectureDetails {
  String? sId;
  String? lectureType;
  String? lectureTitle;
  String? description;
  Teacher? teacher;
  Subject? subject;
  String? link;
  String? liveOrRecorded;
  String? startingDate;
  String? endingDate;
  Material? material;
  String? ytLiveChatId;
  String? commonName;
  bool? isCommentAllowed;
  BatchDetails? batchDetails;
  String? socketUrl;
  String? banner;
  RoomDetails? roomDetails;
  File? dpp;
  String? language;

  LectureDetails({
    this.sId,
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
    this.batchDetails,
    this.commonName,
    this.socketUrl,
    this.banner,
    this.roomDetails,
    this.ytLiveChatId,
    this.dpp,
    this.language,
    this.isCommentAllowed,
  });

  LectureDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    lectureType = json['lecture_type'];
    lectureTitle = json['lecture_title'];
    description = json['description'];
    commonName = json['commonName'];
    socketUrl = json['socketUrl'];
    banner = json['banner'];
    batchDetails = json['batchDetails'] != null ? BatchDetails.fromJson(json['batchDetails']) : null;
    if (json['teacher'] != null) {
      teacher = Teacher.fromJson(json['teacher']);
    }
    if (json['roomDetails'] != null) {
      roomDetails = RoomDetails.fromJson(json['roomDetails']);
    }

    subject = json['subject'] != null ? Subject.fromJson(json['subject']) : null;
    link = json['link'];
    liveOrRecorded = json['LiveOrRecorded'];
    startingDate = json['starting_date'];
    endingDate = json['ending_date'];
    material = json['material'] != null ? Material.fromJson(json['material']) : null;
    ytLiveChatId = json['ytLiveChatId'];
    language = json['language'];
    isCommentAllowed = json['isCommentAllowed'];
    dpp = json["dpp"] != null ? File.fromJson(json["dpp"]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['lecture_type'] = lectureType;
    data['lecture_title'] = lectureTitle;
    data['description'] = description;
    data['commonName'] = commonName;
    data['socketUrl'] = socketUrl;
    data['banner'] = banner;
    if (batchDetails != null) {
      data['batchDetails'] = batchDetails!.toJson();
    }
    if (teacher != null) {
      data['teacher'] = teacher!.toJson();
    }
    if (roomDetails != null) {
      data['roomDetails'] = roomDetails!.toJson();
    }
    if (subject != null) {
      data['subject'] = subject!.toJson();
    }
    data['link'] = link;
    data['LiveOrRecorded'] = liveOrRecorded;
    data['starting_date'] = startingDate;
    data['ending_date'] = endingDate;
    if (material != null) {
      data['material'] = material!.toJson();
    }
    data['ytLiveChatId'] = ytLiveChatId;
    data['language'] = language;
    data["dpp"] = dpp!.toJson();
    data['isCommentAllowed'] = isCommentAllowed;
    return data;
  }
}

class Teacher {
  String? sId;
  String? qualification;
  String? fullName;
  String? profilePhoto;
  String? demoVideo;
  List<Subject>? subject;

  Teacher({
    this.sId,
    this.fullName,
    this.profilePhoto,
    this.subject,
    this.qualification,
    this.demoVideo,
  });

  Teacher.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['FullName'];
    qualification = json['qualification'];
    demoVideo = json['demoVideo'];
    profilePhoto = json['profilePhoto'];
    if (json['subject'] != null) {
      subject = <Subject>[];
      json['subject'].forEach((v) {
        subject!.add(Subject.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['FullName'] = fullName;
    data['qualification'] = qualification;
    data['demoVideo'] = demoVideo;
    data['profilePhoto'] = profilePhoto;
    if (subject != null) {
      data['subject'] = subject!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subject {
  String? sId;
  String? title;
  String? isActive;
  String? user;

  Subject({
    this.sId,
    this.title,
    this.isActive,
    this.user,
  });

  Subject.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    isActive = json['is_active'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['is_active'] = isActive;
    data['user'] = user;
    return data;
  }
}

class Material {
  String? fileLoc;
  String? fileName;
  String? fileSize;

  Material({this.fileLoc, this.fileName, this.fileSize});

  Material.fromJson(Map<String, dynamic> json) {
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

class File {
  String? fileLoc;
  String? fileName;
  String? fileSize;

  File({this.fileLoc, this.fileName, this.fileSize});

  File.fromJson(Map<String, dynamic> json) {
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

class RoomDetails {
  String? id;
  String? title;
  String? batchName;
  List<Mentor>? mentor;

  RoomDetails({this.id, this.title, this.batchName, this.mentor});

  RoomDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    batchName = json['batchName'];
    if (json['mentor'] != null) {
      mentor = <Mentor>[];
      json['mentor'].forEach((v) {
        mentor!.add(Mentor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['batchName'] = batchName;
    if (mentor != null) {
      data['mentor'] = mentor!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Mentor {
  String? mentorId;
  String? mentorName;

  Mentor({this.mentorId, this.mentorName});

  Mentor.fromJson(Map<String, dynamic> json) {
    mentorId = json['mentorId'];
    mentorName = json['mentorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mentorId'] = mentorId;
    data['mentorName'] = mentorName;
    return data;
  }
}

class BatchDetails {
  String? id;
  String? batchName;
  String? slug;

  BatchDetails({this.id, this.batchName, this.slug});

  BatchDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    batchName = json['batchName'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['batchName'] = batchName;
    data['slug'] = slug;
    return data;
  }
}

class BatchFeature {
  String? featureId;
  String? icon;
  String? feature;

  BatchFeature({
    this.featureId,
    this.icon,
    this.feature,
  });

  BatchFeature copyWith({
    String? featureId,
    String? icon,
    String? feature,
  }) =>
      BatchFeature(
        featureId: featureId ?? this.featureId,
        icon: icon ?? this.icon,
        feature: feature ?? this.feature,
      );

  factory BatchFeature.fromJson(String str) => BatchFeature.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BatchFeature.fromMap(Map<String, dynamic> json) => BatchFeature(
        featureId: json["featureId"],
        icon: json["icon"],
        feature: json["feature"],
      );

  Map<String, dynamic> toMap() => {
        "featureId": featureId,
        "icon": icon,
        "feature": feature,
      };
}
