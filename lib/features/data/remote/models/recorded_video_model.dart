class RecordedVideoModel {
  bool? status;
  List<RecordedVideoDataModel>? data;
  String? msg;

  RecordedVideoModel({this.status, this.data, this.msg});

  RecordedVideoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <RecordedVideoDataModel>[];
      json['data'].forEach((v) {
        data!.add(RecordedVideoDataModel.fromJson(v));
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

class RecordedVideoDataModel {
  String? lectureName;
  List<Listofvideos>? listofvideos;

  RecordedVideoDataModel({this.lectureName, this.listofvideos});

  RecordedVideoDataModel.fromJson(Map<String, dynamic> json) {
    lectureName = json['LectureName'];
    if (json['Listofvideos'] != null) {
      listofvideos = <Listofvideos>[];
      json['Listofvideos'].forEach((v) {
        listofvideos!.add(Listofvideos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LectureName'] = lectureName;
    if (listofvideos != null) {
      data['Listofvideos'] = listofvideos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Listofvideos {
  String? sId;
  String? title;
  FileUrl? fileUrl;
  String? batchId;
  String? language;
  LectureId? lectureId;
  bool? isActive;
  String? createdAt;
  bool? isVerfied;

  Listofvideos(
      {this.sId,
      this.title,
      this.fileUrl,
      this.batchId,
      this.language,
      this.lectureId,
      this.isActive,
      this.createdAt,
      this.isVerfied});

  Listofvideos.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    fileUrl = json['file_url'] != null
        ? FileUrl.fromJson(json['file_url'])
        : null;
    batchId = json['batch_id'];
    language = json['language'];
    lectureId = json['lecture_id'] != null
        ? LectureId.fromJson(json['lecture_id'])
        : null;
    isActive = json['is_active'];
    createdAt = json['created_at'];
    isVerfied = json['is_verfied'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    if (fileUrl != null) {
      data['file_url'] = fileUrl!.toJson();
    }
    data['batch_id'] = batchId;
    data['language'] = language;
    if (lectureId != null) {
      data['lecture_id'] = lectureId!.toJson();
    }
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['is_verfied'] = isVerfied;
    return data;
  }
}

class FileUrl {
  String? fileLoc;
  String? fileName;
  String? fileSize;

  FileUrl({this.fileLoc, this.fileName, this.fileSize});

  FileUrl.fromJson(Map<String, dynamic> json) {
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

class LectureId {
  String? sId;
  String? lectureTitle;

  LectureId({this.sId, this.lectureTitle});

  LectureId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    lectureTitle = json['lecture_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['lecture_title'] = lectureTitle;
    return data;
  }
}
