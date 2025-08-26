class AirResourcesModel {
  AirResourcesModel({
    required this.status,
    required this.data,
    required this.msg,
  });

  final bool status;
  final List<AirResourcesDataModel> data;
  final String msg;

  factory AirResourcesModel.fromJson(Map<String, dynamic> json) =>
      AirResourcesModel(
        status: json["status"],
        data: List<AirResourcesDataModel>.from(
            json["data"].map((x) => AirResourcesDataModel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "msg": msg,
      };
}

class AirResourcesDataModel {
  AirResourcesDataModel({
    required this.id,
    required this.user,
    required this.data,
    required this.audioFile,
    required this.language,
    required this.isActive,
    required this.createdAt,
  });

  final String id;
  final String user;
  final String data;
  final AudioFile audioFile;
  final String language;
  final bool isActive;
  final String createdAt;

  factory AirResourcesDataModel.fromJson(Map<String, dynamic> json) =>
      AirResourcesDataModel(
        id: json["_id"],
        user: json["user"],
        data: json["data"],
        audioFile: AudioFile.fromJson(json["audio_file"]),
        language: json["language"],
        isActive: json["is_active"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "data": data,
        "audio_file": audioFile.toJson(),
        "language": language,
        "is_active": isActive,
        "created_at": createdAt,
      };
}

class AudioFile {
  AudioFile({
    required this.fileLoc,
    required this.fileName,
    required this.fileSize,
  });

  final String fileLoc;
  final String fileName;
  final String fileSize;

  factory AudioFile.fromJson(Map<String, dynamic> json) => AudioFile(
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
