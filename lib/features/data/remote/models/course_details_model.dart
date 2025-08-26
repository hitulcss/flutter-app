import 'dart:convert';
import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';

class CoursesDetailsModel {
  bool? status;
  Data? data;
  String? msg;
  bool? isPurchase;

  CoursesDetailsModel({this.status, this.data, this.msg, this.isPurchase});

  CoursesDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    msg = json['msg'];
    isPurchase = json['isPurchase'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = msg;
    data['isPurchase'] = isPurchase;
    return data;
  }
}

class Data {
  BatchDetails? batchDetails;
  int? noOfVideos;
  int? noofNotes;

  Data({this.batchDetails, this.noOfVideos, this.noofNotes});

  Data.fromJson(Map<String, dynamic> json) {
    batchDetails = json['batchDetails'] != null ? BatchDetails.fromJson(json['batchDetails']) : null;
    noOfVideos = json['NoOfVideos'];
    noofNotes = json['NoofNotes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (batchDetails != null) {
      data['batchDetails'] = batchDetails!.toJson();
    }
    data['NoOfVideos'] = noOfVideos;
    data['NoofNotes'] = noofNotes;
    return data;
  }
}

class BatchDetails {
  String? sId;
  String? batchName;
  String? slug;
  String? examType;
  List<String>? student;
  List<Subject>? subject;
  List<Teacher>? teacher;
  String? startingDate;
  String? endingDate;
  String? mode;
  String? materials;
  String? language;
  String? charges;
  String? discount;
  String? description;
  List<Banner>? banner;
  String? stream;
  String? remark;
  List<DemoVideo>? demoVideo;
  String? validity;
  bool? isActive;
  bool? isPaid;
  bool? isCoinApplicable;
  String? maxAllowedCoins;
  String? courseReview;
  String? batchOrder;
  Planner? planner;
  String? createdAt;
  ShareUrl? shareUrl;
  List<GetFaqsData>? faqs;
  List<BatchFeature>? batchFeatures;
  FeatureVideo? featureVideo;

  BatchDetails({
    this.sId,
    this.batchName,
    this.slug,
    this.examType,
    this.student,
    this.subject,
    this.teacher,
    this.startingDate,
    this.endingDate,
    this.mode,
    this.materials,
    this.language,
    this.shareUrl,
    this.charges,
    this.discount,
    this.description,
    this.banner,
    this.stream,
    this.remark,
    this.demoVideo,
    this.validity,
    this.isActive,
    this.isPaid,
    this.isCoinApplicable,
    this.maxAllowedCoins,
    this.courseReview,
    this.batchOrder,
    this.planner,
    this.createdAt,
    this.faqs,
    this.batchFeatures,
    this.featureVideo,
  });

  BatchDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    batchName = json['batch_name'];
    slug = json['slug'];
    examType = json['exam_type'];
    student = json['student'].cast<String>();
    if (json['subject'] != null) {
      subject = <Subject>[];
      json['subject'].forEach((v) {
        subject!.add(Subject.fromJson(v));
      });
    }
    shareUrl = json['shareUrl'] != null ? ShareUrl.fromJson(json['shareUrl']) : null;
    if (json['faqs'] != null) {
      faqs = [];
      json['faqs'].forEach((v) {
        faqs!.add(GetFaqsData.fromJson(v));
      });
    }
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
    if (json['banner'] != null) {
      banner = <Banner>[];
      json['banner'].forEach((v) {
        banner!.add(Banner.fromJson(v));
      });
    }
    stream = json['stream'];
    remark = json['remark'];
    if (json['demoVideo'] != null) {
      demoVideo = <DemoVideo>[];
      json['demoVideo'].forEach((v) {
        demoVideo!.add(DemoVideo.fromJson(v));
      });
    }
    validity = json['validity'];
    isActive = json['is_active'];
    isPaid = json['isPaid'];
    isCoinApplicable = json['isCoinApplicable'];
    maxAllowedCoins = json['maxAllowedCoins'];
    courseReview = json['course_review'];
    batchOrder = json['batchOrder'];
    planner = json['planner'] != null ? Planner.fromJson(json['planner']) : null;
    createdAt = json['created_at'];
    if (json['batchFeatures'] != null) {
      batchFeatures = <BatchFeature>[];
      json['batchFeatures'].forEach((v) {
        batchFeatures!.add(BatchFeature.fromMap(v));
      });
    }
    featureVideo = json["featureVideo"] != null ? FeatureVideo.fromMap(json["featureVideo"]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['batch_name'] = batchName;
    data['slug'] = slug;
    data["shareUrl"] = shareUrl;
    data['exam_type'] = examType;
    data['student'] = student;
    if (subject != null) {
      data['subject'] = subject!.map((v) => v.toJson()).toList();
    }
    if (faqs != null) {
      data['faqs'] = faqs!.map((v) => v.toJson()).toList();
    }
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
    if (banner != null) {
      data['banner'] = banner!.map((v) => v.toJson()).toList();
    }
    data['stream'] = stream;
    data['remark'] = remark;
    if (demoVideo != null) {
      data['demoVideo'] = demoVideo!.map((v) => v.toJson()).toList();
    }
    data['validity'] = validity;
    data['is_active'] = isActive;
    data['isPaid'] = isPaid;
    data['isCoinApplicable'] = isCoinApplicable;
    data['maxAllowedCoins'] = maxAllowedCoins;
    data['course_review'] = courseReview;
    data['batchOrder'] = batchOrder;
    if (planner != null) {
      data['planner'] = planner!.toJson();
    }
    data['created_at'] = createdAt;
    if (batchFeatures != null) {
      data['batchFeatures'] = batchFeatures!.map((v) => v.toJson()).toList();
    }
    if (featureVideo != null) {
      data['featureVideo'] = featureVideo!.toJson();
    }
    return data;
  }
}

class Subject {
  String? sId;
  String? title;

  Subject({this.sId, this.title});

  Subject.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    return data;
  }
}

class Teacher {
  String? sId;
  String? fullName;
  String? profilePhoto;
  List<Subject>? subject;
  String? demodemoVideo;
  String? qualification;
  Teacher({this.sId, this.fullName, this.profilePhoto, this.subject, this.demodemoVideo, this.qualification});

  Teacher.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['FullName'];
    profilePhoto = json['profilePhoto'];
    qualification = json['qualification'];
    demodemoVideo = json['demoVideo'];
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
    data['demoVideo'] = demodemoVideo;
    data['qualification'] = qualification;
    data['profilePhoto'] = profilePhoto;
    if (subject != null) {
      data['subject'] = subject!.map((v) => v.toJson()).toList();
    }
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

class DemoVideo {
  String? fileLoc;
  String? fileName;
  String? fileSize;
  String? demoVideofileType;

  DemoVideo({this.fileLoc, this.fileName, this.fileSize, this.demoVideofileType});

  DemoVideo.fromJson(Map<String, dynamic> json) {
    fileLoc = json['fileLoc'];
    fileName = json['fileName'];
    fileSize = json['fileSize'];
    demoVideofileType = json['DemoVideofileType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileLoc'] = fileLoc;
    data['fileName'] = fileName;
    data['fileSize'] = fileSize;
    data['DemoVideofileType'] = demoVideofileType;
    return data;
  }
}

class Planner {
  String? fileLoc;
  String? fileName;
  String? fileSize;

  Planner({this.fileLoc, this.fileName, this.fileSize});

  Planner.fromJson(Map<String, dynamic> json) {
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

class GetFaqsData {
  String? id;
  String? question;
  String? answer;

  GetFaqsData({this.id, this.question, this.answer});

  GetFaqsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }
}

class ShareUrl {
  String? link;
  String? text;

  ShareUrl({this.link, this.text});

  ShareUrl.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link'] = link;
    data['text'] = text;
    return data;
  }
}

class FeatureVideo {
  String? videoType;
  String? url;

  FeatureVideo({
    this.videoType,
    this.url,
  });

  FeatureVideo copyWith({
    String? videoType,
    String? url,
  }) =>
      FeatureVideo(
        videoType: videoType ?? this.videoType,
        url: url ?? this.url,
      );

  factory FeatureVideo.fromJson(String str) => FeatureVideo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FeatureVideo.fromMap(Map<String, dynamic> json) => FeatureVideo(
        videoType: json["videoType"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "videoType": videoType,
        "url": url,
      };
}
