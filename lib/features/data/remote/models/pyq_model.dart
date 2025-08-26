class PYQModel {
  bool? status;
  List<PYQModelData>? data;
  String? msg;

  PYQModel({this.status, this.data, this.msg});

  PYQModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <PYQModelData>[];
      json['data'].forEach((v) {
        data!.add(PYQModelData.fromJson(v));
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

class PYQModelData {
  Category? category;
  Category? subCategory;
  String? title;
  FileUrl? fileUrl;
  bool? isActive;
  String? language;
  String? createdAt;

  PYQModelData(
      {this.category,
      this.subCategory,
      this.title,
      this.fileUrl,
      this.isActive,
      this.language,
      this.createdAt});

  PYQModelData.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    subCategory = json['subCategory'] != null
        ? Category.fromJson(json['subCategory'])
        : null;
    title = json['title'];
    fileUrl = json['file_url'] != null
        ? FileUrl.fromJson(json['file_url'])
        : null;
    isActive = json['is_active'];
    language = json['language'];
    createdAt = json['created_At'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (subCategory != null) {
      data['subCategory'] = subCategory!.toJson();
    }
    data['title'] = title;
    if (fileUrl != null) {
      data['file_url'] = fileUrl!.toJson();
    }
    data['is_active'] = isActive;
    data['language'] = language;
    data['created_At'] = createdAt;
    return data;
  }
}

class Category {
  String? sId;
  String? title;

  Category({this.sId, this.title});

  Category.fromJson(Map<String, dynamic> json) {
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
