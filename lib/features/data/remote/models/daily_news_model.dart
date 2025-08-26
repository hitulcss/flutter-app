class DailyNewsModel {
  DailyNewsModel({
    required this.status,
    required this.data,
    required this.msg,
  });

  final bool status;
  final List<DailyNewsDataModel> data;
  final String msg;

  factory DailyNewsModel.fromJson(Map<String, dynamic> json) => DailyNewsModel(
    status: json["status"],
    data: List<DailyNewsDataModel>.from(json["data"].map((x) => DailyNewsDataModel.fromJson(x))),
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "msg": msg,
  };
}

class DailyNewsDataModel {
  DailyNewsDataModel({
    required this.id,
    required this.fileUrl,
    required this.title,
    required this.isActive,
    required this.language,
    required this.resourcetype,
    required this.createdAt,
  });

  final String id;
  final FileUrl fileUrl;
  final String title;
  final bool isActive;
  final String language;
  final String resourcetype;
  final String createdAt;

  factory DailyNewsDataModel.fromJson(Map<String, dynamic> json) => DailyNewsDataModel(
    id: json["_id"],
    fileUrl: FileUrl.fromJson(json["file_url"]),
    title: json["title"],
    isActive: json["is_active"],
    language: json["language"],
    resourcetype: json["resource_type"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "file_url": fileUrl.toJson(),
    "title": title,
    "is_active": isActive,
    "resource_type":resourcetype,
    "language": language,
    "created_at": createdAt,
  };
}

class FileUrl {
  FileUrl({
    required this.fileLoc,
    required this.fileName,
    required this.fileSize,
  });

  final String fileLoc;
  final String fileName;
  final String? fileSize;

  factory FileUrl.fromJson(Map<String, dynamic> json) => FileUrl(
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
