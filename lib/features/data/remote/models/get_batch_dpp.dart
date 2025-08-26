class GetBatchDPP {
  bool? status;
  List<GetBatchDPPData>? data;
  String? msg;

  GetBatchDPP({this.status, this.data, this.msg});

  GetBatchDPP.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetBatchDPPData>[];
      json['data'].forEach((v) {
        data!.add(GetBatchDPPData.fromJson(v));
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

class GetBatchDPPData {
  String? id;
  String? lectureTitle;
  File? file;

  GetBatchDPPData({this.id, this.lectureTitle, this.file});

  GetBatchDPPData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lectureTitle = json['lecture_title'];
    file = json['file'] != null ? File.fromJson(json['file']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lecture_title'] = lectureTitle;
    if (file != null) {
      data['file'] = file!.toJson();
    }
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
