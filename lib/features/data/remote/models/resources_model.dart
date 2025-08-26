class ResourcesModel {
  bool? status;
  List<ResourcesDataModle>? data;
  String? msg;

  ResourcesModel({this.status, this.data, this.msg});

  ResourcesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ResourcesDataModle>[];
      json['data'].forEach((v) {
        data!.add(ResourcesDataModle.fromJson(v));
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

class ResourcesDataModle {
  String? sId;
  String? title;
  FileUrl? fileUrl;
  String? language;
  String? createdAt;
  String? resourceType;
  bool? isActive;

  ResourcesDataModle(
      {this.sId,
      this.title,
      this.fileUrl,
      this.language,
      this.createdAt,
      this.resourceType,
      this.isActive});

  ResourcesDataModle.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
   
    title = json['title'];
    fileUrl =
        json['file_url'] != null ? FileUrl.fromJson(json['file_url']) : null;
    language = json['language'];
    createdAt = json['Created_At'];
    resourceType = json['resource_type'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
  
    data['title'] = title;
    if (fileUrl != null) {
      data['file_url'] = fileUrl!.toJson();
    }
    data['language'] = language;
    data['Created_At'] = createdAt;
    data['resource_type'] = resourceType;
    data['is_active'] = isActive;
    return data;
  }
}

class Category {
  String? sId;
  String? title;
  bool? isActive;
  String? createdAt;

  Category({this.sId, this.title, this.isActive, this.createdAt});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
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
