class BatchNotesModel {
  bool? status;
  List<BatchNotesModelData>? data;
  String? msg;

  BatchNotesModel({this.status, this.data, this.msg});

  BatchNotesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <BatchNotesModelData>[];
      json['data'].forEach((v) {
        data!.add(BatchNotesModelData.fromJson(v));
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

class BatchNotesModelData {
  String? title;
  List<Res>? res;

  BatchNotesModelData({this.title, this.res});

  BatchNotesModelData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['res'] != null) {
      res = <Res>[];
      json['res'].forEach((v) {
        res!.add(Res.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (res != null) {
      data['res'] = res!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Res {
  String? resourceTitle;
  String? resourceType;
  File? file;

  Res({this.resourceTitle, this.resourceType, this.file});

  Res.fromJson(Map<String, dynamic> json) {
    resourceTitle = json['resource_title'];
    resourceType = json['resourceType'];
    file = json['file'] != null ? File.fromJson(json['file']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resource_title'] = resourceTitle;
    data['resourceType'] = resourceType;
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
