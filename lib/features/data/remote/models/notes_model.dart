class NotesModel {
  NotesModel({
    required this.status,
    required this.data,
    required this.msg,
  });

  final bool status;
  final List<NotesDataModel> data;
  final String msg;

  factory NotesModel.fromJson(Map<String, dynamic> json) => NotesModel(
        status: json["status"],
        data: List<NotesDataModel>.from(
            json["data"].map((x) => NotesDataModel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "msg": msg,
      };
}

class NotesDataModel {
  NotesDataModel({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.notesType,
    required this.resourcetype,
    required this.isActive,
    required this.language,
  });

  final String id;
  final String title;
  final FileUrl fileUrl;
  final String notesType;
  final String resourcetype;
  final bool isActive;
  final String language;

  factory NotesDataModel.fromJson(Map<String, dynamic> json) => NotesDataModel(
        id: json["_id"],
        title: json["title"],
        fileUrl: FileUrl.fromJson(json["file_url"]),
        notesType: json["notes_type"],
        isActive: json["is_active"],
        resourcetype: json["resource_type"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "file_url": fileUrl.toJson(),
        "notes_type": notesType,
        "resource_type": resourcetype,
        "is_active": isActive,
        "language": language,
      };
}

class FileUrl {
  FileUrl({
    required this.fileLoc,
    required this.fileName,
    required this.fileSize,
  });

  final String fileLoc;
  final String? fileName;
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
